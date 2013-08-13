Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3HMU3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:29:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33925 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758979Ab3HMU3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:29:51 -0400
Date: Tue, 13 Aug 2013 22:29:43 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813222943.46fdacff@skate>
In-Reply-To: <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Tue, 13 Aug 2013 14:25:23 +0200, Sebastian Hesselbarth wrote:

> +		port->reset_gpio = of_get_named_gpio_flags(child,
> +						   "reset-gpios", 0, &flags);
> +		if (gpio_is_valid(port->reset_gpio)) {
> +			u32 reset_udelay = 20000;
> +
> +			port->reset_active_low = flags & OF_GPIO_ACTIVE_LOW;
> +			port->reset_name = kasprintf(GFP_KERNEL,
> +				     "pcie%d.%d-reset", port->port, port->lane);
> +			of_property_read_u32(child, "reset-delay-us",
> +					     &reset_udelay);
> +
> +			ret = devm_gpio_request_one(&pdev->dev,
> +			    port->reset_gpio, GPIOF_DIR_OUT, port->reset_name);
> +			if (ret) {
> +				if (ret == -EPROBE_DEFER)
> +					return ret;
> +				continue;
> +			}
> +
> +			gpio_set_value(port->reset_gpio,
> +				       (port->reset_active_low) ? 1 : 0);
> +			udelay(reset_udelay);
> +		}

Sorry for raising this only now, but I think I would have preferred to
see this reset-gpios handling be moved into a separate sub-function.
The loop initializing each PCIe interface is already quite large, and I
believe moving this reset-gpios thing to a sub-function would have made
sense.

But well, the patches have been applied, and we can always adjust this
with a followup patch.

Jason, have you re-created your for-next branch with all those patches?
I'd like to give them a test if possible.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
