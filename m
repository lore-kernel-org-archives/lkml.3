Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaFPWV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:21:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34284 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaFPWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:21:56 -0400
Message-ID: <539F6C4A.2030005@wwwdotorg.org>
Date: Mon, 16 Jun 2014 16:14:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        tj@kernel.org, pdeschrijver@nvidia.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> This adds support for the integrated AHCI-compliant Serial ATA
> controller present on the NVIDIA Tegra124 system-on-chip.

> diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c

> +static int tegra_ahci_controller_init(struct ahci_host_priv *hpriv)

> +	/* Pad calibration */
> +
> +	ret = tegra_fuse_readl(0x224, &val);
> +	if (ret) {
> +		dev_err(&tegra->pdev->dev,
> +			"failed to read sata calibration fuse: %d\n", ret);
> +		return ret;
> +	}
> +
> +	calib = tegra124_pad_calibration[val];

Shouldn't val be range-checked before blindly using it?
