Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbaHYTgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:36:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37679 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaHYTgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:36:07 -0400
Message-ID: <53FB903E.3050805@wwwdotorg.org>
Date: Mon, 25 Aug 2014 13:36:30 -0600
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
Subject: Re: [PATCH v2 6/9] usb: xhci: Add NVIDIA Tegra xHCI host-controller
 driver
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <1408381705-3623-7-git-send-email-abrestic@chromium.org>
In-Reply-To: <1408381705-3623-7-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> Add support for the on-chip xHCI host controller present on Tegra SoCs.
>
> The driver is currently very basic: it loads the controller with its
> firmware, starts the controller, and is able to service messages sent
> by the controller's firmware.  The hardware supports device mode as
> well as lower-power operating modes, but support for these is not yet
> implemented here.

Just one minor comment below.

I'd like an ack from a USB maintainer so that this patch can be taken 
through the Tegra tree along with the rest of the series, which has 
various dependencies.

> +MODULE_ALIAS("platform:xhci-tegra");

I don't think that's needed; MODULE_DEVICE_TABLE(of, 
tegra_xhci_of_match) should be enough upstream.
