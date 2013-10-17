Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab3JQTKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:10:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48737 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758160Ab3JQTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:10:34 -0400
Date: Thu, 17 Oct 2013 15:10:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: linux-usb@vger.kernel.org,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2 v3] usb: ohci: remove ep93xx bus glue platform driver
In-Reply-To: <201310171125.50024.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.44L0.1310171506210.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, H Hartley Sweeten wrote:

> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
> 
> Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
> is still enabled by default on the EP93xx platform.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

> +/*************************************************************************
> + * EP93xx OHCI USB Host
> + *************************************************************************/
> +
> +static struct clk *ep93xx_ohci_host_clock;
> +
> +static int ep93xx_ohci_power_on(struct platform_device *pdev)
> +{
> +	if (!ep93xx_ohci_host_clock) {
> +		ep93xx_ohci_host_clock = devm_clk_get(&pdev->dev, NULL);
> +		if (IS_ERR(ep93xx_ohci_host_clock))
> +			return PTR_ERR(ep93xx_ohci_host_clock);
> +	}
> +
> +	clk_enable(ep93xx_ohci_host_clock);
> +
> +	return 0;

Wasn't this supposed to be changed to:

	return clk_enable(ep93xx_ohci_host_clock);

?  Otherwise it looks fine.  After fixing this, you can add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

