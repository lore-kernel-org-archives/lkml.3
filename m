Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaFERJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:09:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53123 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaFERI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:08:58 -0400
Message-ID: <5390A426.1050307@wwwdotorg.org>
Date: Thu, 05 Jun 2014 11:08:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: Add NVIDIA Tegra XUSB pad controller support
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 09:16 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The XUSB pad controller found on NVIDIA Tegra SoCs provides several pads
> that lanes can be assigned to in order to support a variety of interface
> options: USB 2.0, USB 3.0, PCIe and SATA.
> 
> In addition to the pin controller used to assign lanes to pads two PHYs
> are exposed to allow the bricks for PCIe and SATA to be powered up and
> down by PCIe and SATA drivers.

> +#define TEGRA124_GROUP(_funcs)						\
> +	{								\
> +		.num_funcs = ARRAY_SIZE(tegra124_##_funcs##_functions),	\
> +		.funcs = tegra124_##_funcs##_functions,			\
> +	}
> +
> +static const struct tegra_xusb_padctl_group tegra124_groups[] = {
> +	TEGRA124_GROUP(otg),
> +	TEGRA124_GROUP(usb),
> +	TEGRA124_GROUP(pci),
> +};

I'm not sure what this set of groups is for.

pinctrl muxes functions onto groups, so given that each pin in padctl is
individually configurable, we need 1 group per pin. As far as I can
tell, tegra_xusb_padctl_get_groups_count()/name() implement this
correctly, and this array isn't used anywhere?
