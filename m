Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3JHNTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:19:55 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:39507 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3JHNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:19:54 -0400
Message-ID: <52540674.5030402@bjorling.me>
Date: Tue, 08 Oct 2013 15:19:48 +0200
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH RFC 0/2] Convert from bio-based to blk-mq
References: <1381224862-5299-1-git-send-email-m@bjorling.me> <20131008131036.GC7422@linux.intel.com>
In-Reply-To: <20131008131036.GC7422@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 03:10 PM, Matthew Wilcox wrote:
> On Tue, Oct 08, 2013 at 11:34:20AM +0200, Matias Bjørling wrote:
>> The nvme driver implements itself as a bio-based driver. This primarily because
>> of high lock congestion for high-performance nvm devices. To remove the
>> congestion, a multi-queue block layer is being implemented.
>
> Um, no.  You'll crater performance by adding another memory allocation
> (of the struct request).  multi-queue is not the solution.
>

Agree that there shouldn't be yet another allocation. blk-mq allocates 
the requests upfront for that reason. Additionally, nvme_cmd_info can be 
handled within the request payload.
