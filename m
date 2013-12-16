Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3LPSrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:47:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56754 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3LPSrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:47:02 -0500
Message-ID: <52AF4AA0.60006@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:46:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 07/12] iommu/tegra: smmu: register device to iommu dynamically
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-8-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-8-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> platform_devices are registered as IOMMU'able dynamically via
> add_device() and remove_device().

That says {add,remove}_device() ...

> Tegra SMMU can have multiple address spaces(AS). IOMMU'able devices
> can belong to one of them. Multiple IOVA maps are created at boot-up,
> which can be attached to devices later. We reserve 2 of them for
> static assignment, AS[0] for system default, AS[1] for AHB clusters as
> protected domain from others, where there are many traditional
> pheripheral devices like USB, SD/MMC. They should be isolated from
> some smart devices like host1x for system robustness. Even if smart
> devices behaves wrongly, the traditional devices(SD/MMC, USB) wouldn't
> be affected, and the system could continue most likely. DMA API(ARM)
> needs ARM_DMA_USE_IOMMU to be enabled.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v6:
> Use smmu_iommu_{bound,unbind}_driver() instead of
> smmu_iommu_{add,del}_device() to register devices to SMMU.

... yet that says it's been changed to {bound,unbind}_driver(). BTW,
what was the reason for this change?
