Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3AWNks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:40:48 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:56711
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341Ab3AWNkq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:40:46 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371I15bfK542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz17326ah8275dh8275bhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH2ZBS-01-39E-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgA==
Date: Wed, 23 Jan 2013 13:40:39 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
 <CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
In-Reply-To: <CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.13.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Tuesday, January 22, 2013 6:57 PM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
> 
> On Tue, Jan 22, 2013 at 11:55 AM, Shuah Khan <shuahkhan@gmail.com>
> wrote:
> 
> >>> init:
> >>
> >> Does the attached patch stop them?  It basically skips all initialization of
> the DMA ring on your system.  What I don't understand is why you still get
> them with the previous patch, but not with
> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.
> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of the
> DMA ring for buffer migration and the patch I previously attached disables
> the use of the DMA ring for buffer migration.  Does the latest batch of drm-
> fixes from Dave that Linus just merged help?
> >>
> >> Alex
> >
> > Will try your latest patch. Will also try the latest git - I am
> > currently on Jan 17th. However, in the meantime, I found that these
> > messages might not be new and getting printed now with the
> > eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon: print
> dma
> > status reg on lockup (v2) commit that introduced debug messages in
> > r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
> > compile with these messages commented out. Will update you on the
> > results and then test the new git
> >
> > -- Shuah
> 
> Here is what I tried:
> 
> 1. Applied your latest disable_dma_ring_on_6xx-2.diff and still see
> messages.

If that is the case, I'm beginning to think the bug is elsewhere.  Support for the DMA ring was the only major feature we added in this cycle.  If you are still getting errors even with the ring completely disabled, it's probably not the DMA ring.

Make sure your kernel has this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=20707874fd4fd37e09513f508e642fa8bd06365a
That's the only thing I can think of that may cause the DMAR errors if the DMA ring is disabled.

> 2. Tried intel_iommu=igfx_off to see if that changes anything. The
> reason for trying this option is, I noticed this message: (this is not
> a new message, I see this all the time)
> 
> [    1.337112] DMAR: Disabling IOMMU for graphics on this chipset
> 
> No change with or without option - still see the same messages.
> 
> Next steps:
> 
> 1. One big difference between 3.7 and 3.8 is in the
> r600_gpu_soft_reset() - I started with 3.7 to see the differences if
> any of these differences is causing this to be logged. In 3.7
> r600_gpu_soft_reset() is called with no reset_mask. I am going to
> first verify if softreset happens on 3.7. Does this give you any ideas
> of whether this could cause a problem?

I don't think the problem is related to GPU reset.  That's for resetting the GPU when it hangs.  It changed slightly in 3.8 to accommodate the new DMA engine that we added support for in 3.8.  Previously we just reset the graphics engine.

> 
> 2. Another angle I am looking at is the newly added
> 
> dev_info(rdev->dev, "  R_00D034_DMA_STATUS_REG   = 0x%08X\n",
>                 RREG32(DMA_STATUS_REG));
> 
> messages in r600_gpu_soft_reset_dma().
> 
> Could it be that these newly added debug messages are now showing this
> old condition that always existed on my test system. From what I have
> observed so far, this is very likely.

I'm not following.  That just prints the DMA status register when we attempt to reset the GPU.  It's purely for debugging.

Alex

> 
> Please let me know if you want to me try anything else or if you don't
> think these steps won't help.
> 
> -- Shuah


