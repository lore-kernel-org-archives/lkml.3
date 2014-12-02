Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbaLBIRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:17:32 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41853 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaLBIRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:17:30 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.62.239]
In-Reply-To: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
Date: Tue, 2 Dec 2014 09:17:28 +0100
Message-ID: <CABxcv=mmJp2c=ZC8=0+TW0-x3g7RnELTAFY24KJRjUgf+QrDcQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On Mon, Nov 24, 2014 at 6:41 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> DP PHY now require pmu-system-controller to handle PMU register
> to control PHY's power isolation. Adding the same to dp-phy
> node.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Kukjin Kim <kgene@kernel.org>

Any opinions about $subject?

This patch is -rc material since is needed after commit a5ec598 ("phy:
exynos-dp-video: Use syscon
support to control pmu register") which landed in 3.18. That means
that display for Exynos is currently broken in 3.18.

I think it's too late for the 3.18 -rc cycle but at least it would be
great to have this merged for 3.19 and backport to stable kernels to
have display working again.

Thierry had concerns that this change breaks DT backward compability
but actually it was already been broken by a5ec598 which changed the
DT binding for the phy-exynos-dp-video driver so we should either
apply this patch now or revert a5ec598.

Thanks a lot and best regards,
Javier
