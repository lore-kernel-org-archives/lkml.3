Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3CMUCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:02:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49940 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3CMUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:02:44 -0400
Message-ID: <5140DB61.3090809@wwwdotorg.org>
Date: Wed, 13 Mar 2013 14:02:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/5] ARM: tegra:add aliases and DMA requestor for serial
 nodes of Tegra114
References: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com> <1363204194-19487-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363204194-19487-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 01:49 PM, Laxman Dewangan wrote:
> Add APB DMA requestor and serial aliases for serial controller.
> There will be two serial driver i.e. 8250 based simple serial driver
> and APB DMA based serial driver for higher baudrate and performace.
> 
> The simple serial driver get enabled with compatible "nvidia,tegra114-uart",
> "nvidia,tegra20-uart" and APB DMA based driver will get enabled with
> compatible "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".

> +	/*
> +	 * There are two serial driver i.e. 8250 based simple serial
> +	 * driver and APB DMA based serial driver for higher baudrate
> +	 * and performace. To enable the 8250 based driver, the compatible
> +	 * is "nvidia,tegra114-uart", "nvidia,tegra20-uart" and to enable
> +	 * the APB DMA based serial driver, the comptible is
> +	 * "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart".
> +	 */

Again, that text says you want either of:

compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
compatible = "nvidia,tegra114-hsuart", "nvidia,tegra30-hsuart";

(note Tegra20-vs-Tegra30 in the second compatible value)

Why isn't it instead:

compatible = "nvidia,tegra114-uart",   "nvidia,tegra20-uart";
compatible = "nvidia,tegra114-hsuart", "nvidia,tegra20-hsuart";

(note both second compatible values say Tegra20)

I assume this is a typo.

I suppose I can fix this up when I apply it to avoid a resend, assuming
it's wrong.
