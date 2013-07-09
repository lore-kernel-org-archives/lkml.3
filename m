Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3GIWbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 18:31:11 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40327 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GIWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:31:10 -0400
Date: Tue, 9 Jul 2013 15:31:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130709223106.GA16429@roeck-us.net>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 03:05:39PM -0600, Bjorn Helgaas wrote:
> [+cc Joerg, David, iommu list]
> 
> On Tue, Jul 9, 2013 at 2:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > I started seeing this problem after updating the BIOS trying fix another issue,
> > though I may have missed it earlier.
> >
> > I understand this is a BIOS bug. Would be great if someone can pass this on
> > to Intel BIOS engineers.
> 
> Maybe.  It'd be nice if Linux handled it better, though.
> 
If anyone has an idea how to do that, I'll be happy to write a patch.

Guenter

> > CPU is i7-4770K.
> >
> > Guenter
> >
> > ---
> >
> > [    0.000000] WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar+0x86/0xa0()
> > [    0.000000] Your BIOS is broken; DMAR reported at address 0!
> > [    0.000000] BIOS vendor: Intel Corp.; Ver: RLH8710H.86A.0320.2013.0606.1802; Product Version:
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0+ #1
> > [    0.000000] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0320.2013.0606.1802 06/06/2013
> > [    0.000000]  000000000000000b ffffffff81c01e20 ffffffff81671cfc ffffffff81c01e68
> > [    0.000000]  ffffffff81c01e58 ffffffff81043370 ffffffff81f6800c ffffffff81cbb520
> > [    0.000000]  0000000000000000 ffff88061fdaad40 00000000c73cc018 ffffffff81c01eb8
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff81671cfc>] dump_stack+0x45/0x56
> > [    0.000000]  [<ffffffff81043370>] warn_slowpath_common+0x70/0xa0
> > [    0.000000]  [<ffffffff81043404>] warn_slowpath_fmt_taint+0x44/0x50
> > [    0.000000]  [<ffffffff81d162eb>] ? early_ioremap+0x13/0x15
> > [    0.000000]  [<ffffffff81d0d6a6>] ? __acpi_map_table+0x13/0x1a
> > [    0.000000]  [<ffffffff81548bf6>] warn_invalid_dmar+0x86/0xa0
> > [    0.000000]  [<ffffffff81d4b994>] check_zero_address+0x57/0xf7
> > [    0.000000]  [<ffffffff81d4ba49>] detect_intel_iommu+0x15/0xb6
> > [    0.000000]  [<ffffffff81d07d28>] pci_iommu_alloc+0x49/0x70
> > [    0.000000]  [<ffffffff81d15de4>] mem_init+0x17/0x9c
> > [    0.000000]  [<ffffffff81d01c54>] start_kernel+0x1c5/0x3e2
> > [    0.000000]  [<ffffffff81d01898>] ? repair_env_string+0x5e/0x5e
> > [    0.000000]  [<ffffffff81d015a3>] x86_64_start_reservations+0x2a/0x2c
> > [    0.000000]  [<ffffffff81d0169b>] x86_64_start_kernel+0xf6/0xf9
> > [    0.000000] ---[ end trace a7e3512e2fa85eaf ]---
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
