Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaF2Ttk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:49:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33012 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaF2Tti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:49:38 -0400
Message-ID: <53B06DD0.8030106@codeaurora.org>
Date: Sun, 29 Jun 2014 12:49:36 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] CMA page migration failure due to buffers on bh_lru
References: <53A8D092.4040801@lge.com> <xa1td2dvmznq.fsf@mina86.com> <53ACAB82.6020201@lge.com>
In-Reply-To: <53ACAB82.6020201@lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc-ing Hugh since he had comments on the patch before)

On 6/26/2014 4:23 PM, Gioh Kim wrote:
> 
> 
> 2014-06-27 오전 12:57, Michal Nazarewicz 쓴 글:
>> On Tue, Jun 24 2014, Gioh Kim <gioh.kim@lge.com> wrote:
>>> Hello,
>>>
>>> I am trying to apply CMA feature for my platform.
>>> My kernel version, 3.10.x, is not allocating memory from CMA area so that I applied
>>> a Joonsoo Kim's patch (https://lkml.org/lkml/2014/5/28/64).
>>> Now my platform can use CMA area effectively.
>>>
>>> But I have many failures to allocate memory from CMA area.
>>> I found the same situation to Laura Abbott's patch descrbing,
>>> https://lkml.org/lkml/2012/8/31/313,
>>> that releases buffer-heads attached at CPU's LRU list.
>>>
>>> If Joonsoo's patch is applied and/or CMA feature is applied more and more,
>>> buffer-heads problem is going to be serious definitely.
>>>
>>> Please look into the Laura's patch again.
>>> I think it must be applied with Joonsoo's patch.
>>
>> Just to make sure I understood you correctly, you're saying Laura's
>> patch at <https://lkml.org/lkml/2012/8/31/313> fixes your issue?
>>
> 
> Yes, it is.

I submitted this before and it was suggested that this was more
related to filesystems

http://marc.info/?l=linaro-mm-sig&m=137645770708817&w=2

I never saw more discussion and pushed this into the 'CMA hacks' pile. 
So far we've been keeping the patch out of tree and it's useful to know
that others have found the same problem. I'm willing to resubmit the
patch for further discussion.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
