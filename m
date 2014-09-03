Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaICQZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:25:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59940 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaICQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:25:18 -0400
Message-ID: <54073F17.2050507@wwwdotorg.org>
Date: Wed, 03 Sep 2014 10:17:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 6/9] usb: xhci: Add NVIDIA Tegra xHCI host-controller
 driver
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org> <1409693701-16520-7-git-send-email-abrestic@chromium.org>
In-Reply-To: <1409693701-16520-7-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 03:34 PM, Andrew Bresticker wrote:
> Add support for the on-chip xHCI host controller present on Tegra SoCs.
>
> The driver is currently very basic: it loads the controller with its
> firmware, starts the controller, and is able to service messages sent
> by the controller's firmware.  The hardware also supports device mode
> as well as powergating of the SuperSpeed and host-controller logic
> when not in use, but support for these is not yet implemented.

> diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c

> +static bool is_host_mbox_message(u32 cmd)
> +{
> +	switch (cmd) {
> +	case MBOX_CMD_INC_SSPI_CLOCK:
> +	case MBOX_CMD_DEC_SSPI_CLOCK:
> +	case MBOX_CMD_INC_FALC_CLOCK:
> +	case MBOX_CMD_DEC_FALC_CLOCK:
> +		return true;
> +	case MBOX_CMD_SET_BW:
> +		/*
> +		 * TODO: Request bandwidth once EMC scaling is supported.
> +		 * Ignore for now since ACK/NAK is not required for SET_BW
> +		 * messages.
> +		 */

I think that TODO belongs inside tegra_xhci_mbox_work() where the 
message would actually be handled, if implemented.
