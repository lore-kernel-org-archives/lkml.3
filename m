Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3L0Qfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:35:37 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:32805 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab3L0Qff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:35:35 -0500
Message-ID: <52BDAC02.4020404@gmail.com>
Date: Fri, 27 Dec 2013 18:34:10 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: tomi.valkeinen@ti.com, tony@atomide.com, linux@arm.linux.org.uk,
        pali.rohar@gmail.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] ARM: omapfb: Add early framebuffer memory allocator
References: <52A062A0.3070005@ti.com> <1388013159-3036-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20131227094801.GB17143@amd.pavel.ucw.cz>
In-Reply-To: <20131227094801.GB17143@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27.12.2013 11:48, Pavel Machek wrote:
> On Thu 2013-12-26 01:12:39, Ivaylo Dimitrov wrote:
>> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>>
>> On memory limited devices, CMA fails easily when asked to allocate big
>> chunks of memory like framebuffer memory needed for video playback.
>>
>> Add boot parameter "omapfb_memsize" which allocates memory to be used
>> as dma coherent memory, so dma_alloc_attrs won't hit CMA allocator when
>> trying to allocate memory for the framebuffers
>>
>> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Hmm, would it make sense to add a parameter to reserve certain ammount
> of memory for CMA? omapfb is probably not the only user hitting
> this...?
> 									Pavel

But that would mean that one must have CMA enabled to use that 
functionality and it is an additional memory overhead. Also, I don't 
think we will have much of a benefit of that - for video playback we'll 
still have to preallocate the same amount of RAM as now - but with the 
additional overhead of page migration when that RAM becomes needed by 
DSP and OMAPFB. However, even if such functionality is someday 
implemented in CMA, it doesn't conflict with the proposed patch - by 
simply not preallocating memory for omapfb, one will automatically use it.

BTW there is CMEM driver (not upstreamed afaik) which does exactly that 
- it manages a contiguous ("stolen")memory pool. No idea how easy it 
would be to merge CMEM into CMA. Neither I am the right guy for the 
task, IMO :)

Ivo
