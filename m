Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3EMRRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:17:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40084 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3EMRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:17:22 -0400
Message-ID: <5191201F.2070606@wwwdotorg.org>
Date: Mon, 13 May 2013 11:17:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 01/10] ARM: tegra: finalize USB EHCI and PHY bindings
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com> <1368194051-4925-2-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1368194051-4925-2-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 07:54 AM, Venu Byravarasu wrote:
> The existing Tegra USB bindings have a few issues:
> 
> 1) Many properties are documented as being part of the EHCI controller
> node, yet they apply more to the PHY device. They should be moved.
> 
> 2) Some registers in PHY1 are shared with PHY3, and hence PHY3 needs a
> reg entry to point at PHY1's register space. We can't assume the PHY1
> driver is present, so the PHY3 driver will directly access those
> registers.
> 
> 3) The list of clocks required by the PHY was missing some required
> entries.
> 
> 4) UTMI PHY Timing parameters are added
> 
> 5) VBUS control is now specified using a regulator rather than a plain GPIO
> 
> 6) Added nvidia,is-wired property to indicate whether the device is
> hard wired on the board, or pluggable.
> 
> This patch fixes the binding definition to resolve these issues.

> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt

> +    the USB controller.
> +  - nvidia,is-wired : boolean. Indicates whether we can do certain kind of power
> +    optimizations for the devices that are always connected. e.g. modem.
> +  - dr_mode : dual role mode. Indicates the working mode for the PHY. Can be
> +    "host", "peripheral", or "otg". Defaults to "host" if not defined.
> +      host means this is a host controller
> +      peripheral means it is device controller
> +      otg means it can operate as either ("on the go")

Nit: Please leave a blank line here, to separate the sections/lists.

> +Required properties for dr_mode == otg:
> +  - vbus-supply: regulator for VBUS
> \ No newline at end of file

Nit: Since you're reposting this series for other reasons, I'd like to
fix that "No newline at end of file"; please add a newline here.
