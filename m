Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaGABiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:38:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:14382 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaGABiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:38:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="555553406"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Jingoo Han <jg1.han@samsung.com>, David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v3] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v3] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: AQHPlGlM48LVHsbFaUGVfkhEl9ZAOZuKcCdw
Date: Tue, 1 Jul 2014 01:38:51 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E947AD9@SHSMSX101.ccr.corp.intel.com>
References: <1404147960-17596-1-git-send-email-alvin.chen@intel.com>
 <1404147960-17596-2-git-send-email-alvin.chen@intel.com>
 <53B1697E.8060708@cogentembedded.com>
In-Reply-To: <53B1697E.8060708@cogentembedded.com>
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

> > /*--------------------------------------------------------------------
> > -----*/
> > +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> > +static inline bool is_intel_quark_x1000(struct pci_dev *pdev) {
> > +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> > +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> > +}
> 
>     Why not just put this check inline into ehci_pci_reinit()?
Alan Stern said it is not a problem, I think so also since it just a inline subroutine.

> 
> > +
> > +/*
> > +	* The offset of in/out threshold register is 0x84.
> > +	* And it is the register of 'hostpc'
> > +	* in memory-mapped EHCI controller.
> > +*/
> 
>     The preferred multi-line kernel style is this:
> 
> /*
>   * bla
>   * bla
>   */
I will improve it.

> > +#define	intel_quark_x1000_insnreg01	hostpc
> > +
> > +/* The maximal ehci packet buffer size is 512 bytes */
> 
>     s/ehci/EHCI/
> 
> > +#define INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE	512
> > +
> > +/* The threshold value set the register is in DWORD */
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD(size)	((size)/4u)
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT	16
> > +#define INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT	0
> > +
> >
> 
>     Too many empty lines...
> 
> >   /* called after powerup, by probe or system-pm "wakeup" */
> >   static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
> >   {
> >   	int			retval;
> > +	u32			val;
> > +	u32			thr;
> 
>     Why not declare these where they are used?
All will be removed as Alan Stern's suggestion.

> > +	/* Reset the threshold limit */
> > +	if (is_intel_quark_x1000(pdev)) {
> > +		/*
> > +			* In order to support the isochronous/interrupt
> > +			* transactions, 508 bytes should be used as
> > +			* max threshold values to maximize the
> > +			* performance
> > +		*/
> 
>     Same comment about the comment style...
> 
> > +		thr = INTEL_QUARK_X1000_EHCI_THRESHOLD(
> > +			INTEL_QUARK_X1000_EHCI_MAX_PACKET_BUFFER_SIZE - 4
> > +			);
> > +		val = thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_OUT_SHIFT |
> > +				thr<<INTEL_QUARK_X1000_EHCI_THRESHOLD_IN_SHIFT;
> 
>     Please surround << with spaces for consistency.
The above code will be removed as Alan Stern's suggestion.

> 

