Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaEGSAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:00:50 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44378 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaEGSAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:00:48 -0400
Date: Wed, 7 May 2014 20:00:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Bodo Eggert <7eggert@gmx.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86/gart: Tidy messages and add bridge device info
Message-ID: <20140507180040.GA17329@gmail.com>
References: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140425171655.312.97511.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140426060130.GA1698@gmail.com>
 <CAErSpo4ttY-423De+4=TCsK0kXeZRanoEL2yUjp=GVAoZGaOLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4ttY-423De+4=TCsK0kXeZRanoEL2yUjp=GVAoZGaOLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Sat, Apr 26, 2014 at 12:01 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Bjorn Helgaas <bhelgaas@google.com> wrote:
> >
> >> Print the AGP bridge info the same way as the rest of the kernel, e.g.,
> >> "0000:00:04.0" instead of "00:04:00".
> >>
> >> Also print the AGP aperture address range the same way we print resources,
> >> and label it explicitly as a bus address range.
> >>
> >> No functional change.
> >>
> >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >> ---
> >>  arch/x86/kernel/aperture_64.c |   20 ++++++++++++--------
> >>  1 file changed, 12 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> >> index 9fa8aa051f54..4dd76d3df056 100644
> >> --- a/arch/x86/kernel/aperture_64.c
> >> +++ b/arch/x86/kernel/aperture_64.c
> >> @@ -126,10 +126,12 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
> >>       u64 aper;
> >>       u32 old_order;
> >>
> >> -     printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
> >> +     printk(KERN_INFO "pci 0000:%02x:%02x.%d: AGP bridge\n", bus, slot,
> >> +            func);
> >
> > Please leave it on a single line - checkpatch warning nonwithstanding.
> > pr_info() is also useful.
> > ...
> 
> > Also, you could add:
> >
> > #define PREFIX "PCI/gart: "
> >
> > or something like that, to define a standard prefix for these
> > messages.
> 
> I converted to pr_info(), etc. and added pr_fmt for an "AGP: " prefix.
> 
> > Btw., this file could be moved to arch/x86/pci/?
> 
> Yes, I'd be glad to do this.  It looks like all the following files
> might be candidates:
> 
>   amd_gart_64.c  (CONFIG_GART_IOMMU)
>   aperture_64.c  (CONFIG_GART_IOMMU)
>   pci-calgary_64.c  (CONFIG_CALGARY_IOMMU)
>   tce_64.c  (CONFIG_CALGARY_IOMMU)
>   mmconf-fam10h_64.c  (CONFIG_PCI_MMCONFIG)
> 
> What do you think?  Move all, move none, move only aperture_64.c?
> 
> Thanks for your comments!

Please move all of them, they are really 95% PCI bits:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
