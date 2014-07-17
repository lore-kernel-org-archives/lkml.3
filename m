Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaGQKWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:22:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbaGQKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:22:11 -0400
Date: Thu, 17 Jul 2014 12:22:52 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140717102252.GA17987@dhcp-26-207.brq.redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
 <20140716222024.GE14366@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716222024.GE14366@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:20:24PM -0600, Bjorn Helgaas wrote:
> > @@ -809,22 +799,23 @@ out_free:
> >  }
> >  
> >  /**
> > - * pci_msi_check_device - check whether MSI may be enabled on a device
> > + * msi_check_device - check whether MSI may be enabled on a device
> >   * @dev: pointer to the pci_dev data structure of MSI device function
> >   * @nvec: how many MSIs have been requested ?
> > - * @type: are we checking for MSI or MSI-X ?
> >   *
> >   * Look at global flags, the device itself, and its parent buses
> >   * to determine if MSI/-X are supported for the device. If MSI/-X is
> >   * supported return 0, else return an error code.
> >   **/
> > -static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
> > +static int msi_check_device(struct pci_dev *dev, int nvec)
> 
> I think "check_device" is a terrible name because it really doesn't
> give a clue about what it's doing or what the return value means.
> Since you're removing the external usage (arch_msi_check_device) and
> this one is static, this would be a good time to fix it.  Maybe
> "pci_msi_supported()" or something?

What about pci_can_enable_msi() or pci_msi_can_enable() or msi_can_enable()?

> I *love* the idea of getting rid of this much code!
> 
> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
