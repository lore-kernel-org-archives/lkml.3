Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbbALPmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:42:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbbALPma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:42:30 -0500
Message-ID: <1421077333.6130.21.camel@redhat.com>
Subject: Re: [PATCH 0/3] PCI/x86: Interface for testing multivector MSI
 support
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Date: Mon, 12 Jan 2015 08:42:13 -0700
In-Reply-To: <20150108161521.GB6575@google.com>
References: <20141121213752.31095.30735.stgit@gimli.home>
	 <20150108161521.GB6575@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 09:15 -0700, Bjorn Helgaas wrote:
> On Fri, Nov 21, 2014 at 03:08:27PM -0700, Alex Williamson wrote:
> > I'd like to make vfio-pci capable of manipulating the device exposed
> > to the user such that if the host can only support a single MSI
> > vector then we hide the fact that the device itself may actually be
> > able to support more.  When we virtualize PCI config space and
> > interrupt setup there's no PCI protocol for the device failing to
> > allocate the number of vectors that it said were available.  If the
> > userspace driver is a guest operating system, it certainly doesn't
> > expect this to fail.  I don't think we can ever guarantee that a
> > multi-vector request will succeed, but we can certainly guarantee
> > that it will fail if the platform doesn't support it.
> > 
> > An example device is the Atheros AR93xxx running in a Windows 7 VM.
> > Both the device and the guest OS support multiple MSI vectors.  With
> > interrupt remapping, such that the host supports multivector, the
> > device works well in the guest.  With interrupt remapping disabled,
> > the device is far less reliable because of the mismatch in MSI
> > programming vs driver configuration and often fails.  If vfio-pci
> > can test whether multiple vectors are supported, then we can make it
> > work reliably in both cases by adjusting the exposed MSI capability,
> > like in this patch that would follow this series:
> > 
> > https://github.com/awilliam/linux-vfio/commit/9ace67515680
> > 
> > With this series, only x86 w/ interrupt remapping will advertise
> > support for multiple MSI vectors.  In surveying the code, I couldn't
> > find any other archs that allowed it, but I'll take corrections if
> > that's untrue.  Thanks,
> 
> Per Thomas' comments and your possible workaround if we don't have
> pci_msi_supported(), I'm going to ignore these for now.  Let me know if
> you disagree.

Yep, that's fine.  I'll either forget about this for a while or kludge
something in vfio to know that only x86 with interrupt remapping, which
I can test from the IOMMU API, has multivector MSI support.  Thanks,

Alex

