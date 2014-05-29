Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaE2QAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:00:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56941 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaE2QAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:00:18 -0400
Message-ID: <538757B6.4010109@wwwdotorg.org>
Date: Thu, 29 May 2014 09:52:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: Arnd Bergmann <arnd@arndb.de>, Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 02:36 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This commit introduces a generic device tree binding for IOMMU devices.
> Only a very minimal subset is described here, but it is enough to cover
> the requirements of both the Exynos System MMU and Tegra SMMU as
> discussed here:
> 
>     https://lkml.org/lkml/2014/4/27/346
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Apologies for the noise, but apparently I mistyped one of the email
> addresses, should be fixed now.
> 
> Changes in v2:
> - add notes about "dma-ranges" property (drop note from commit message)
> - document priorities of "iommus" property vs. "dma-ranges" property
> - drop #iommu-cells in favour of #address-cells and #size-cells

I think this is a mistake. address-cells/size-cells are for transactions
flowing down the bus (from the CPU to date). Describing a connection
from a device to an IOMMU is something completely different, and should
therefore simply use an iommu-cells property to describe any necessary
information. If we start re-using properties for different things in
different contexts, how is anyone going to know what they mean, and how
will conflicts be resolved. For example, what if there's a single HW
module that both acts as a regular register bus with children (where
address-cells/size-cells defines how transactions reach the children
from the parent), and is also an IOMMU (where according to this binding
proposal, address-cells/size-cells represent some aspect of the IOMMU
feature). Using different properties for different things is the only
sane way to keep different concepts separate. Another alternative would
be to represent the single HW module as separate nodes in DT, but I
think that will only make our lives harder, and where I've done that in
the past, I've regretted it.
