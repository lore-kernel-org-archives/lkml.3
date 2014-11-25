Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaKYPNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:13:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48157 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKYPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:13:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,456,1413244800"; 
   d="scan'208";a="196587022"
Date: Tue, 25 Nov 2014 15:12:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>,
        <jun.nakajima@intel.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>
Subject: Re: [PATCH v3 1/2] xen/pci: Defer initialization of MSI ops on HVM
 guests until after x2APIC has been set up
In-Reply-To: <54749C2B.4090303@oracle.com>
Message-ID: <alpine.DEB.2.02.1411251511580.2675@kaball.uk.xensource.com>
References: <1416870378-32481-1-git-send-email-boris.ostrovsky@oracle.com> <1416870378-32481-2-git-send-email-boris.ostrovsky@oracle.com> <alpine.DEB.2.02.1411251205220.2675@kaball.uk.xensource.com> <54749C2B.4090303@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Boris Ostrovsky wrote:
> On 11/25/2014 07:06 AM, Stefano Stabellini wrote:
> > On Mon, 24 Nov 2014, Boris Ostrovsky wrote:
> > > If the hardware supports APIC virtualization we may decide not to use
> > > pirqs
> > > and instead use APIC/x2APIC directly, meaning that we don't want to set
> > > x86_msi.setup_msi_irqs and x86_msi.teardown_msi_irq to Xen-specific
> > > routines.
> > > However, x2APIC is not set up by the time pci_xen_hvm_init() is called so
> > > we
> > > need to postpone setting these ops until later, when we know which APIC
> > > mode
> > > is used.
> > > 
> > > (Note that currently x2APIC is never initialized on HVM guests. This may
> > > change in the future)
> > I take that this is safe because no MSIs can be received at this point
> > (apic_post_init), right?
> 
> 
> Yes. At the time apic_post_init() is called PCI has not been probed yet.

Please add that to the commit message.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
