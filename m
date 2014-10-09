Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaJIKSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:18:17 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:52236 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaJIKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
References: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 9 Oct 2014 15:48:09 +0530
Message-ID: <CAEC9eQPMNcGxUZVAh6ou6a=6V9bAgmwZAn5ra4=EkoosNURWPg@mail.gmail.com>
Subject: Re: [PATCH 0/3] drm-exynos-dp/phy-exynos-dp: Refactor to use
 pmu-system-controller and dp driver cleanup
From: Ajay kumar <ajaynumb@gmail.com>
To: InKi Dae <inki.dae@samsung.com>, Vivek Gautam <gautam.vivek@samsung.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Sean Paul <seanpaul@google.com>,
        kishon@ti.com, Ajay Kumar <ajaykumar.rs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 15, 2014 at 6:43 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> These patches are based on 'for-next' branch of kgene's linux-samsung tree.
>
> Refactoring the exynos-dp-video phy to use pmu-system-controller handle
> and access the register using mfd-syscon and regmap.
> Simultaneously, removing the support for older dptx-phy, since it's obsolete
> now and noone uses it.
>
> Vivek Gautam (3):
>   phy: exynos-dp-video: Use syscon support to control pmu register
>   drm/exynos: dp: Remove support for unused dptx-phy
>   arm: dts: Exynos5: Use pmu_system_controller phandle for dp phy
>
>  .../devicetree/bindings/phy/samsung-phy.txt        |    7 +-
>  arch/arm/boot/dts/exynos5250.dtsi                  |    2 +-
>  arch/arm/boot/dts/exynos5420.dtsi                  |    4 +-
>  drivers/gpu/drm/exynos/exynos_dp_core.c            |   58 ++++-----------
>  drivers/gpu/drm/exynos/exynos_dp_core.h            |    2 -
>  drivers/phy/phy-exynos-dp-video.c                  |   76 ++++++++++++++------
>  6 files changed, 75 insertions(+), 74 deletions(-)
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have tested this patchset on exynos5800-peach-pi, and I can see DP
display with the above patches.

Ajay
