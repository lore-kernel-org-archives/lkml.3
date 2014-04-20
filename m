Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaDTR4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 13:56:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52102 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751076AbaDTR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 13:56:16 -0400
Date: Sun, 20 Apr 2014 13:56:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
cc: leoli@freescale.com, <balbi@ti.com>, <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <kalluripunnaiahchoudary@gmail.com>, <kpc528@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [RFC PATCH 0/2] usb: Reuse fsl driver code for synopsys usb
 controller
In-Reply-To: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
Message-ID: <Pine.LNX.4.44L0.1404201354410.7666-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2014, Punnaiah Choudary Kalluri wrote:

> Zynq soc contains a dual role usb controller and this IP is from synopsys. We
> observed that there is driver available for this controller from freescale and
> decided to reuse this driver for zynq use.
> 
> Here is the link for zynq soc TRM. Please refer chapter 15 for usb controller
> related information.
> http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
> 
> The following series of patches add initial support for zynq soc in fsl gadget controller
> driver and fsl host controller driver.
> 
> Based on these patches, I have the following concerns and sugesstions
> 
> Since the freescale usb driver is for synopsys IP, Please consider rebranding
> this driver name and config options to reflect that it is a sysnopsys IP. So
> that other vendors who using this IP can reuse thie driver.
> 
> Also the ehci-fsl.c is for powerpc based soc's, and zynq is ARM based, i have
> protected the code which is specifc to freescale with CONFIG_FSL_SOC. Please
> suggest if there is a better way of doing this?

Filling the code with #ifdef lines is definitely not a good way to go.  
Ordinary "if" statements would be a lot better, if you can't figure out 
a reasonable way to encapsulate the differences.

Alan Stern

