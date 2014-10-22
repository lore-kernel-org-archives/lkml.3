Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaJVPM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:12:58 -0400
Received: from 8bytes.org ([81.169.241.247]:36968 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbaJVPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:12:56 -0400
Date: Wed, 22 Oct 2014 17:12:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Simon Xue <xxm@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] iommu/rockchip: rk3288 iommu driver
Message-ID: <20141022151254.GJ10074@8bytes.org>
References: <1413273762-32489-1-git-send-email-djkurtz@chromium.org>
 <1413273762-32489-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413273762-32489-2-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:02:40PM +0800, Daniel Kurtz wrote:
> +static void rk_iommu_detach_device(struct iommu_domain *domain,
> +				   struct device *dev)
> +{
> +	struct rk_iommu *iommu = dev_get_drvdata(dev->archdata.iommu);
> +	struct rk_iommu_domain *rk_domain = domain->priv;
> +	unsigned long flags;
> +
> +	/* Allow 'virtual devices' (eg drm) to detach from domain */
> +	if (!iommu)
> +		return;
> +
> +	iommu->domain = NULL;

I guess this line is a left-over? Setting iommu->domain to NULL here
before you disabled the IOMMU interrupt is racy. To be fully secure, you
should make sure that no interrupt handler is still running after you
disabled the IOMMU irq and before setting iommu->domain = NULL.

Other than that the code looks good.


	Joerg

