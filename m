Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3GPQs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:48:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58092 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932889Ab3GPQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:48:54 -0400
Date: Tue, 16 Jul 2013 12:48:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boris BREZILLON <b.brezillon@overkiz.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] USB: ohci-at91: add usb_clk for transition to
 common clk framework
In-Reply-To: <1373988136-24622-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <Pine.LNX.4.44L0.1307161246130.1032-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Boris BREZILLON wrote:

> The AT91 PMC (Power Management Controller) provides an USB clock used by
> USB Full Speed host (ohci) and USB Full Speed device (udc).
> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
> This configuration was formely done in mach-at91/clock.c, but this
> implementation will be removed when moving to common clk framework.
> 
> This patch add support for usb clock retrieval and configuration, and is
> backward compatible with the current at91 clk implementation (if usb clk
> is not found, it does not configure/enable the usb clk).

But it does print a warning in the system log, right?

> @@ -144,6 +150,11 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>  		goto err2;
>  	}
>  
> +	uclk = clk_get(&pdev->dev, "usb_clk");
> +	if (IS_ERR(uclk)) {
> +		uclk = NULL;
> +		dev_warn(&pdev->dev, "failed to get usb_clk\n");
> +	}

Is this really what you want for backward compatibility?

Alan Stern

