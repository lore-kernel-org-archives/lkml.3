Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3KGVsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:48:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35514 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3KGVrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:47:53 -0500
Date: Thu, 7 Nov 2013 14:47:50 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] PCI: Introduce two new MSI infrastructure
 calls for masking/unmasking.
Message-ID: <20131107214750.GB2955@google.com>
References: <1383772616-23060-1-git-send-email-konrad.wilk@oracle.com>
 <CAErSpo4rdHwhuF=SM6WT3EP3TGoUFnwxVdx5919qxea3On7MRw@mail.gmail.com>
 <20131107014215.GA27725@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107014215.GA27725@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:42:15PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Nov 06, 2013 at 04:51:52PM -0700, Bjorn Helgaas wrote:
> > [+cc Thomas, Ingo, Peter, x86 list]
> > 
> > On Wed, Nov 6, 2013 at 2:16 PM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > > Certain platforms do not allow writes in the MSI-X bars
> > > to setup or tear down vector values. To combat against
> > > the generic code trying to write to that and either silently
> > > being ignored or crashing due to the pagetables being marked r/o
> > > this patch introduces a platform over-write.
> > >
> > > Note that we keep two separate, non-weak, functions
> > > default_mask_msi_irqs() and default_mask_msix_irqs() for the
> > > behavior of the arch_mask_msi_irqs() and arch_mask_msix_irqs(),
> > > as the default behavior is needed by x86 PCI code.
> > >
> > > For Xen, which does not allow the guest to write to MSI-X
> > > tables - as the hypervisor is solely responsible for setting
> > > the vector values - we implement two nops.
> > >
> > > CC: Bjorn Helgaas <bhelgaas@google.com>
> > > CC: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> > > CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > I think this is safe, and I'd like to squeeze it into the v3.13 merge
> > window next week, since it supersedes three patches Zhenzhong has been
> > trying to get in since July [1], and this patch is much simpler to
> > understand.
> > 
> > I *think* this also fixes an actual bug on Xen.  Konrad, is there a
> > bugzilla or any kind of email problem description that we can include
> > here as a reference?  I think there's a lost interrupt with qlcnic,
> > but I don't know the details or what the failure looks like to a user.
> 
> It is pretty catastrophic. Here is the console log when I pass in
> a PCI device (with MSI-X) to the guest:

Perfect, thanks!  I put the log info in
https://bugzilla.kernel.org/show_bug.cgi?id=64581 and put this in
my pci/misc branch for v3.13.  I added the following to the changelog:

    This fixes a Xen guest crash when passing a PCI device with MSI-X to the
    guest.  See the bugzilla for more details.

    [bhelgaas: add bugzilla info]
    Reference: https://bugzilla.kernel.org/show_bug.cgi?id=64581

Let me know if this needs any tweaking.

Bjorn
