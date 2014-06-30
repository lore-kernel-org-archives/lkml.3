Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaF3WZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:25:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39691 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaF3WZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:25:06 -0400
Message-ID: <53B1E3BB.1030407@wwwdotorg.org>
Date: Mon, 30 Jun 2014 16:24:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
CC: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree bindings
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1403815790-8548-3-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 02:49 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346

> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Documentation/devicetree/bindings/iommu/iommu.txt

> +When an "iommus" property is specified in a device tree node, the IOMMU will
> +be used for address translation. If a "dma-ranges" property exists in the
> +device's parent node it will be ignored. An exception to this rule is if the
> +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
> +parent shall take effect.

I wonder how useful that paragraph is. The fact that someone disabled a
particular IOMMU's node doesn't necessarily mean that the HW can
actually do that; an IOMMU might always be active in HW and always
translate accesses by some master. In that case, the fallback to
dma-ranges wouldn't correlate with what the HW actually does. Perhaps
all we need is to add a note to that effect here?
