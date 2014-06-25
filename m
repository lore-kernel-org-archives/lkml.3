Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaFYJY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:24:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:47353 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaFYJY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="560660754"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Index: AQHPj6+p5BxdJArRXUevrLYTW6T4oZuBjqRA
Date: Wed, 25 Jun 2014 09:24:36 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E946EE0@SHSMSX101.ccr.corp.intel.com>
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
 <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
 <20140624132444.GA1215@kroah.com>
In-Reply-To: <20140624132444.GA1215@kroah.com>
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

See my comments below:

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, June 24, 2014 9:25 PM
> To: Chen, Alvin
> Cc: Alan Stern; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Ong,
> Boon Leong
> Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel Quark
> X1000
> 
> On Tue, Jun 24, 2014 at 08:51:43AM -0700, Chen, Alvin wrote:
> > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> >
> > This patch is to enable USB host controller for Intel Quark X1000. Add
> > pci quirks to adjust the packet buffer in/out threshold value, and
> > ensure EHCI packet buffer i/o threshold value is reconfigured to half.
> >
> > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> > ---
> >  drivers/usb/host/ehci-pci.c   |    4 ++++
> >  drivers/usb/host/pci-quirks.c |   42
> +++++++++++++++++++++++++++++++++++++++++
> >  drivers/usb/host/pci-quirks.h |    2 ++
> >  3 files changed, 48 insertions(+)
> >
> > diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> > index 3e86bf4..33cfa23 100644
> > --- a/drivers/usb/host/ehci-pci.c
> > +++ b/drivers/usb/host/ehci-pci.c
> > @@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct
> pci_dev *pdev)
> >  	if (!retval)
> >  		ehci_dbg(ehci, "MWI active\n");
> >
> > +	/* Reset the threshold limit */
> > +	if(unlikely(usb_is_intel_qrk(pdev)))
> 
> Why unlikely()?  Have you measured a speed difference here?  And this is a
> _very_ slow path, what does that speed difference you measured help with?
> 
Actually, 'unlikely' is not necessary, I will remove it in PATCH v2.

> thanks,
> 
> greg k-h
