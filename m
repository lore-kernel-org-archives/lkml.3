Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaJ0AB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:01:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42133 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaJ0AB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:01:56 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <544D8B64.3010501@lge.com>
Date: Mon, 27 Oct 2014 09:01:40 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
CC: devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 1/3] staging: ion: shrink page-pool by page unit
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com> <1414133248-639-2-git-send-email-gioh.kim@lge.com> <544AB20A.8090208@codeaurora.org>
In-Reply-To: <544AB20A.8090208@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-25 오전 5:09, Laura Abbott 쓴 글:
> Hi,
>
> On 10/23/2014 11:47 PM, Gioh Kim wrote:
>> This patch shrink page-pool by page unit.
>>
>
> Can you explain a bit more about what this patch is
> fixing? The description in the cover letter would
> be helpful here.

I'm sorry for the lack of explanation.

First, I wanted to shrink ion page-pool, but there was no way for it.
So I checked the existing codes and found a problem.

ion_page_pool_total() returns the number of pages in the pool,
so ion_heap_shrink_count() returns also the number of pages.
ion_page_pool_shrink() takes the argument nr_to_scan as the number of chunk, a bunch of pages.

The system shrinker calls ion_heap_shrink_count() to get nr_to_scan,
and pass it to ion_page_pool_shrink().
The problem is the argument of ion_page_pool_shrink() is the amount of chunk to be shrinked.

We have to make both of them take number of page or chunk respectively.

The first patch is doing it.

The second one is, based on the first patch, making shrink interface via debugfs.
The third is for extra interface.

>
> Thanks,
> Laura
>
