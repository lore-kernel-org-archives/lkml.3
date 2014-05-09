Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbaEIPzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:55:45 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:54169 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756796AbaEIPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:55:43 -0400
Message-ID: <536CFA78.9050609@codethink.co.uk>
Date: Fri, 09 May 2014 16:55:36 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mmc: sdhci: add a driver for Berlin SoCs
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com> <1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/14 13:40, Antoine Ténart wrote:
> Add a Driver to support the SDHCI controller of the Marvell Berlin SoCs.
> This controller supports 3 sockets.

[snip]

> +
> +static struct sdhci_ops sdhci_berlin_ops = {
> +	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_berlin2_pdata = {
> +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> +		  SDHCI_QUIRK_BROKEN_ADMA |
> +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> +	.ops = &sdhci_berlin_ops,
> +};
> +
> +static struct sdhci_pltfm_data sdhci_berlin2q_pdata = {
> +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> +		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
> +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> +	.ops = &sdhci_berlin_ops,
> +};
> +
> +static const struct of_device_id sdhci_berlin_of_match_table[] = {
> +	{
> +		.compatible = "marvell,berlin2-sdhci",
> +		.data = &sdhci_berlin2_pdata,
> +	},
> +	{
> +		.compatible = "marvell,berlin2cd-sdhci",
> +		.data = &sdhci_berlin2_pdata,
> +	},
> +	{
> +		.compatible = "marvell,berlin2q-sdhci",
> +		.data = &sdhci_berlin2q_pdata,
> +	},
> +	{}

I think the hardware names should be used instead of the
quirks the hardware has (broken wp / broken adma)



-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
