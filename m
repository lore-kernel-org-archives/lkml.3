Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaLCRsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:48:02 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:29082 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaLCRsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:48:01 -0500
Message-ID: <547F4CC2.2090801@free.fr>
Date: Wed, 03 Dec 2014 18:47:46 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Creating 16 MB super-sections for MMIO
References: <547D97A5.4090302@free.fr> <20141203103211.GB7373@e104818-lin.cambridge.arm.com> <547F1C11.5090408@free.fr> <2452742.elcJohDinR@wuerfel>
In-Reply-To: <2452742.elcJohDinR@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 18:06, Arnd Bergmann wrote:

> Mason wrote:
>
>> As far as I could tell, Linux does not create a super-section in the
>> case outlined above. Perhaps I misread the source code?
>
> I believe you are right, and I also agree that in theory implementing
> what you say (both 64k and 16M mappings) can only help, but it's not
> obvious if this makes a measurable difference in the end.

It will be an interesting thought experiment to come up with
a relevant benchmark. TODO.

> MMIO register accesses are usually slow for other reasons, and
> they tend to be rare,

Reading e.g. the system tick counter on this SoC takes ~65 ns
(so ~65 cycles from the CPU's PoV) which is roughly twice as
fast as accessing uncached RAM.

I don't think we can say that MMIO registers accesses are slow
when they are faster than RAM, right?

> so it's possible that you won't be able
> to ever tell a difference because the MMIO TLB often gets evicted
> by user mappings between accesses to different 1MB sections,
> and the timing difference between a TLB-hot and cold MMIO access
> might not be that great (depending on the latency of a particular
> register).

I don't know if other SoCs are built differently, but on this one,
most drivers are hammering the same 16MB memory region where the
MMIO registers live. I don't think the entry would ever get evicted
if there's some kind of LRU-policy in action.

[Seems it might worthwhile to investigate TLB entry lockdown
(on Cortex A9) after all.]

> I don't think there would be any objections to doing superpage
> or supersection mappings for early page tables if you can show
> any benefit whatsoever, but it may be hard to come up with a
> scenario where it's actually measurable.

I'll have to think about it.

Thanks.
