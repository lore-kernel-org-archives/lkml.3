Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbaGAOMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:12:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36886 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754308AbaGAOMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:12:15 -0400
Date: Tue, 1 Jul 2014 10:12:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Chen, Alvin" <alvin.chen@intel.com>
cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v4] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
In-Reply-To: <1404227734-14825-2-git-send-email-alvin.chen@intel.com>
Message-ID: <Pine.LNX.4.44L0.1407011009240.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
> USB host controller, and the default value is 0x20 dwords. The in/out threshold
> can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
> but only when isochronous/interrupt transactions are not initiated by the USB
> host controller. This patch is to reconfigure the packet buffer in/out
> threshold as maximal as possible to maximize the performance, and 0x7F dwords
> (508 Bytes) should be used because the USB host controller initiates
> isochronous/interrupt transactions.
> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

There's one error in the style...

> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..429434d 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -35,6 +35,21 @@ static const char hcd_name[] = "ehci-pci";
>  #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
>  
>  /*-------------------------------------------------------------------------*/
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +}
> +
> +/*
> +	* 0x84 is the offset of in/out threshold register,
> +	* and it is the same offset as the register of 'hostpc'.
> +	*/

This comment isn't formatted right.  It should be like this:

/*
 * blah blah blah
 * blah blah blah
 */

If you want to submit a corrected version, you can.  Or Greg may be
willing to fix the style when he merges this patch.

Alan Stern

