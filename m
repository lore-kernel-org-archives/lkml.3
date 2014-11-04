Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKDDi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:38:59 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50563 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017AbaKDDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:38:55 -0500
Message-ID: <54584A48.9000409@hurleysoftware.com>
Date: Mon, 03 Nov 2014 22:38:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CMA: test_pages_isolated failures in alloc_contig_range
References: <2457604.k03RC2Mv4q@avalon> <xa1tsii8l683.fsf@mina86.com> <544F9EAA.5010404@hurleysoftware.com> <xa1tfve8ku7q.fsf@mina86.com>
In-Reply-To: <xa1tfve8ku7q.fsf@mina86.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:57 PM, Michal Nazarewicz wrote:
>> On 10/28/2014 08:38 AM, Michal Nazarewicz wrote:
>>> Like Laura wrote, the message is not (should not be) a problem in
>>> itself:
>>
>> [...]
>>
>>> So as you can see cma_alloc will try another part of the cma region if
>>> test_pages_isolated fails.
>>>
>>> Obviously, if CMA region is fragmented or there's enough space for only
>>> one allocation of required size isolation failures will cause allocation
>>> failures, so it's best to avoid them, but they are not always avoidable.
>>>
>>> To debug you would probably want to add more debug information about the
>>> page (i.e. data from struct page) that failed isolation after the
>>> pr_warn in alloc_contig_range.
> 
> On Tue, Oct 28 2014, Peter Hurley <peter@hurleysoftware.com> wrote:
>> If the message does not indicate an actual problem, then its printk level is
>> too high. These messages have been reported when using 3.16+ distro kernels.
> 
> I think it could be argued both ways.  The condition is not an error,
> since in many cases cma_alloc will be able to continue, but it *is* an
> undesired state.  As such it's not an error but feels to me a bit more
> then just information, hence a warning.  I don't care either way, though.

This "undesired state" is trivially reproducible on 3.16.y on the x86 arch;
a smattering of these will show up just building a distro kernel.

