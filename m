Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3KHPff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:35:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3KHPfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:35:33 -0500
Date: Fri, 8 Nov 2013 10:35:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] PCI: Introduce two new MSI infrastructure calls for
 masking/unmasking.
Message-ID: <20131108153507.GA24755@phenom.dumpdata.com>
References: <1383772616-23060-1-git-send-email-konrad.wilk@oracle.com>
 <CAErSpo4rdHwhuF=SM6WT3EP3TGoUFnwxVdx5919qxea3On7MRw@mail.gmail.com>
 <527C41E9.6040002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527C41E9.6040002@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 09:44:09AM +0800, Zhenzhong Duan wrote:
> 
> On 2013-11-07 07:51, Bjorn Helgaas wrote:
> >[+cc Thomas, Ingo, Peter, x86 list]
> >
> >On Wed, Nov 6, 2013 at 2:16 PM, Konrad Rzeszutek Wilk
> ><konrad.wilk@oracle.com> wrote:
> >>Certain platforms do not allow writes in the MSI-X bars
> >>to setup or tear down vector values. To combat against
> >>the generic code trying to write to that and either silently
> >>being ignored or crashing due to the pagetables being marked r/o
> >>this patch introduces a platform over-write.
> >>
> >>Note that we keep two separate, non-weak, functions
> >>default_mask_msi_irqs() and default_mask_msix_irqs() for the
> >>behavior of the arch_mask_msi_irqs() and arch_mask_msix_irqs(),
> >>as the default behavior is needed by x86 PCI code.
> >>
> >>For Xen, which does not allow the guest to write to MSI-X
> >>tables - as the hypervisor is solely responsible for setting
> >>the vector values - we implement two nops.
> >>
> >>CC: Bjorn Helgaas <bhelgaas@google.com>
> >>CC: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> >>CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> >>Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >I think this is safe, and I'd like to squeeze it into the v3.13 merge
> >window next week, since it supersedes three patches Zhenzhong has been
> >trying to get in since July [1], and this patch is much simpler to
> >understand.
> This patch could replace the first two.
> I think the third patch of mine is still needed as it does a
> different thing.
> It optimizes restore path in dom0.

I tried to rebase it on top of this patch but it ended up that
you still need the two arguments (for restore_... operation). 

But perhaps there is a better way. If you can rebase on top
of this patch - and send it out - that would be great!
