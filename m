Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3BFTQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:16:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9492 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3BFTQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:16:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Feb 2013 11:16:40 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Feb 2013 20:16:35 +0100
Subject: Re: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on
 TEGRA_IOMMU_SMMU
Thread-Topic: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on
 TEGRA_IOMMU_SMMU
Thread-Index: Ac4EnnyJ7MZT4w/8TdKR19R6zdUgmA==
Message-ID: <20130206.211635.744922728615926717.hdoyu@nvidia.com>
References: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com><5112A642.1020800@wwwdotorg.org>
In-Reply-To: <5112A642.1020800@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 6 Feb 2013 19:51:46 +0100:

> On 02/06/2013 11:34 AM, Hiroshi Doyu wrote:
> > New SoC, Tegra114 also uses SMMU. Change tegra_ahb_enable_smmu()'s
> > dependency from ARCH_TEGRA_3x_SOC to TEGRA_IOMMU_SMMU. No need to edit
> > whenever a new Tegra SoC comes.
> > 
> > The following combination caused build error, which this patch fixes.
> > 
> > CONFIG_ARCH_TEGRA_2x_SOC=y
> > \# CONFIG_ARCH_TEGRA_3x_SOC is not set
> > CONFIG_ARCH_TEGRA_114_SOC=y
> > 
> > drivers/iommu/tegra-smmu.c:485: undefined reference to 'tegra_ahb_enable_smmu'
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> Russell, I assume Hiroshi should upload this to your patch tracker? It's
> needed for 3.9.

FYI: Submitted as:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7640/1
