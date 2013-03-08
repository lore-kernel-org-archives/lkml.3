Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab3CHRvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:51:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48617 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3CHRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:51:11 -0500
Message-ID: <513A250C.1000202@wwwdotorg.org>
Date: Fri, 08 Mar 2013 10:51:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH 1/5] ARM: DT: tegra114: add APB DMA controller DT entry
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com> <1362750782-15174-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362750782-15174-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 06:52 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
> APB DMA controllers and make it compatible with "nvidia,tegra114-apbdma".

> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi

> +	apbdma: dma {
> +		compatible = "nvidia,tegra114-apbdma";

So I know that the Tegra114 HW has a new channel-pause feature, which
the driver /can/ use. However, if the driver didn't know about that
feature, and continued to use the global-pause feature, would it still
work fine?

In other words, is the Tegra114 HW 100% backwards-compatible with the
Tegra30 HW, it's just that there are new features that SW could
optionally use?

If that is true, then we should also include "nvidia,tegra30-apbdma" in
the compatible value.
