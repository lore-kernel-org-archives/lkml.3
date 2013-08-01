Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3HAOjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:39:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57676 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756349Ab3HAOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:39:41 -0400
Date: Thu, 1 Aug 2013 10:39:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boris BREZILLON <b.brezillon@overkiz.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ohci-at91: add usb_clk for transition to common
 clk framework
In-Reply-To: <1375337800-2605-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <Pine.LNX.4.44L0.1308011038380.1534-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013, Boris BREZILLON wrote:

> The AT91 PMC (Power Management Controller) provides an USB clock used by
> USB Full Speed host (ohci) and USB Full Speed device (udc).
> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
> This configuration was formely done in mach-at91/clock.c, but this
> implementation will be removed when moving to common clk framework.
> 
> This patch adds support for usb clock retrieval and configuration, and is
> backward compatible with the current at91 clk implementation (if usb clk
> is not found, it does not configure/enable it).
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

> @@ -163,6 +169,8 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>  		goto err5;
>  	}
>  
> +	uclk = clk_get(&pdev->dev, "usb_clk");

What happens if uclk isn't found but it is needed?

Alan Stern

