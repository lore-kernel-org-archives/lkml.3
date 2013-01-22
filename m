Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3AVSwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:52:05 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35760 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3AVSwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:52:02 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50FED729.8020405@ionic.de>
References: <50F9DF53.4090601@ionic.de>
	<CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com>
	<50FC6731.3020209@ionic.de>
	<CAKMK7uEX0CG4LaVr3jkcPeQYTYFseG-G5f0_2zKTuCcfVfhF2g@mail.gmail.com>
	<50FD84E0.2090901@ionic.de>
	<50FED729.8020405@ionic.de>
Date: Tue, 22 Jan 2013 19:52:00 +0100
Message-ID: <CAKMK7uGEaNb3o0jBNRLUN_=Mv7m1KXx28bEFTva3B_3H8_BWng@mail.gmail.com>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 7:15 PM, Mihai Moldovan <ionic@ionic.de> wrote:
> * On 21.01.2013 07:11 PM, Mihai Moldovan wrote:
>> I'm also currently testing a kernel without the Intel IOMMU feature
>> [CONFIG_INTEL_IOMMU=n, but CONFIG_IOMMU_SUPPORT=y]. [...] At least
>> not seeing USB and PCI(e) issues. I'll leave the box running for some
>> more [time] [...]
>
> No freezes for >22h, seems to be fine.
>
>
>> [...] and will afterwards disable IOMMU as a whole to see if I hit
>> USB and PCI(e) issues again with that combination.
>
> The systems seems to run stable with CONFIG_IOMMU_SUPPORT=n set, too. This is
> expected.
> However: unlike during earlier tests when I disabled IOMMU and Intel IOMMU via
> kernel/boot parameters, I am not seeing any DMA mapping errors.
>
> There seems to be a difference between disabling IOMMU/Intel IOMMU statically in
> the kernel compared to disabling it via kernel parameter. Is this another bug?

Behaviour should be the same for the actual dma access at the hw
layer, but if you disable things at compile-time at least drm/i915
selects different paths. We've recently killed those though since it's
not worth the complexity at all. But dunno why you still get dma
errors, that shouldn't be possible. Maybe David has an idea.

> I've attached both kernel ring buffer logs (minus the timings for easier diffing.)
>
>   [*] kern-new-iommu_off.log.bz2 disables IOMMU and Intel IOMMU via boot parameter
>   [*] kern-iommu_static_off.log.bz2 has CONFIG_IOMMU_SUPPORT=n set and any IOMMU
> support statically disabled (also consequently DMAR)

In any case I'll ping David about my 2nd quirk patch and whether
that's something which makes sense and could be merged. Thanks a lot
for all the testing you've done.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
