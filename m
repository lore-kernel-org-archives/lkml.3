Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaFZFYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:24:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:30082 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaFZFYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:24:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="553469362"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: AQHPj7VO5BxdJArRXUevrLYTW6T4oZuBj+kg
Date: Thu, 26 Jun 2014 05:24:39 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E94733A@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <Pine.LNX.4.44L0.1406240959270.990-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406240959270.990-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch is to enable USB host controller for Intel Quark X1000. Add 
>> pci quirks to adjust the packet buffer in/out threshold value, and 
> >ensure EHCI packet buffer i/o threshold value is reconfigured to half
>
>
> What is the packet buffer in/out threshold value and why does it need to be
> reconfigured to half?
> 
I go through the hardware specification carefully again. The EHCI buffer packet depth can be 512 bytes, and the in/out threshold is programmable and can be programmed to 512 bytes (0x80 DWord) only when isochronous/interrupt transactions are not initiated by the host controller. The default threshold value for Quark X1000 is 0x20 DWord, so this patch try to program it as maximal as possible, and it is 0x7F Dword since the host controller initiates isochronous/interrupt transactions .

I will update the description in PATCH v2.

> > +	val = readl(op_reg_base + EHCI_INSNREG01);
> > +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> > +
> > +	val = EHCI_INSNREG01_THRESH;
> > +
> > +	writel(val, op_reg_base + EHCI_INSNREG01);
> > +
> > +	val = readl(op_reg_base + EHCI_INSNREG01);
> > +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> 
> What good will these log messages do anybody?  Is there any reason not to
> make them debug messages?  Or even leave them out entirely, since you
> pretty much know beforehand what they're going to say?
> 
These messages are not necessary, I will remove them.

> > +
> > +	iounmap(base);
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(usb_set_qrk_bulk_thresh);
> 
> None of this material belongs in pci-quirks.c.  Please move it into ehci-pci.c.
> 

OK. I will move them to ehci-pci.c, since these two functions will not be called by other modules.

> Alan Stern

