Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaH3VQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:16:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaH3VP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:15:59 -0400
Date: Sat, 30 Aug 2014 14:15:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 6/9] usb: xhci: Add NVIDIA Tegra xHCI host-controller
 driver
Message-ID: <20140830211558.GA13814@kroah.com>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <1408381705-3623-7-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408381705-3623-7-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:08:22AM -0700, Andrew Bresticker wrote:
> Add support for the on-chip xHCI host controller present on Tegra SoCs.
> 
> The driver is currently very basic: it loads the controller with its
> firmware, starts the controller, and is able to service messages sent
> by the controller's firmware.  The hardware supports device mode as
> well as lower-power operating modes, but support for these is not yet
> implemented here.

So you are saying the device doesn't really work?  Can it handle USB
transactions properly?

I have a jetson board here, is this the controller for that hardware?
Can I test this series on that platform, or is it for something else?

> +static const struct tegra_xhci_soc_config tegra124_soc_config = {
> +	.firmware_file = "nvidia/tegra124/xusb.bin",
> +};
> +MODULE_FIRMWARE("nvidia/tegra124/xusb.bin");

Has this file been submitted to the linux-firmware tree?

thanks,

greg k-h
