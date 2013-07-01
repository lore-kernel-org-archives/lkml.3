Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3GAVSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:18:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38633 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755057Ab3GAVSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:18:51 -0400
Date: Mon, 1 Jul 2013 17:18:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
Subject: Re: [PATCH 0/4] usb: ohci-ep93xx: do a bit of house cleaning
In-Reply-To: <201306281726.49367.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.44L0.1307011714450.1547-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, H Hartley Sweeten wrote:

> Tidy up this driver a bit.
> 
> H Hartley Sweeten (4):
>   usb: ohci-ep93xx: use devm_ioremap_resource()
>   usb: ohci-ep93xx: use platform_get_irq()
>   usb: ohci-ep93xx: use devm_clk_get()
>   usb: ohci-ep93xx: tidy up ohci_hcd_ep93xx_drv_probe()

Patches 1 - 3 look fine; you can add my Acked-by: to them.

For patch 4, we really should have a little more tidying up.  The 
ohci_hcd_ep93xx_drv_probe() routine should be merged with 
usb_hcd_ep93xx_probe(); there's no reason for them to be separate.  
Likewise for ohci_hcd_ep93xx_drv_remove() and usb_hcd_ep93xx_remove().

Also, if you feel up to it, I think it would make sense to eliminate 
the ep93xx_start_hc() and ep93xx_stop_hc() routines and simply call 
clk_enable() and clk_disable() directly.  The extra level of 
redirection does not add any clarity.

Alan Stern

