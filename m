Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3BFSvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:51:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59801 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3BFSvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:51:49 -0500
Message-ID: <5112A642.1020800@wwwdotorg.org>
Date: Wed, 06 Feb 2013 11:51:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on TEGRA_IOMMU_SMMU
References: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 11:34 AM, Hiroshi Doyu wrote:
> New SoC, Tegra114 also uses SMMU. Change tegra_ahb_enable_smmu()'s
> dependency from ARCH_TEGRA_3x_SOC to TEGRA_IOMMU_SMMU. No need to edit
> whenever a new Tegra SoC comes.
> 
> The following combination caused build error, which this patch fixes.
> 
> CONFIG_ARCH_TEGRA_2x_SOC=y
> \# CONFIG_ARCH_TEGRA_3x_SOC is not set
> CONFIG_ARCH_TEGRA_114_SOC=y
> 
> drivers/iommu/tegra-smmu.c:485: undefined reference to 'tegra_ahb_enable_smmu'

Tested-by: Stephen Warren <swarren@nvidia.com>

Russell, I assume Hiroshi should upload this to your patch tracker? It's
needed for 3.9.

Hiroshi, for reference, see:
http://www.arm.linux.org.uk/developer/patches/
