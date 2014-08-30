Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaICNLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:11:40 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40320 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaICNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:11:37 -0400
Date: Fri, 29 Aug 2014 22:39:30 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com,
        kgene.kim@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 0/2] thermal: exynos: Add support for TRIMINFO feature
 of Exynos3250
Message-ID: <20140830023928.GC23645@developer>
References: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409713743-6124-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 03, 2014 at 12:09:01PM +0900, Chanwoo Choi wrote:
> This patchset add the support of TRIMINFO_RELOAD feature for Exynos3250.
> But Exynos3250 has two TRIMINFO_CTRL register instead other Exynos has only one
> TRIMINFO_CTRL register. So, this patchset support the some Exynos SoC which
> has more than one TRIMINF_CTRL.
> 
> Also, this patchset fix wrong value of TRIMINFO_RELOAD_SHIFT and remove
> duplicate code when reading triminfo register of Exynos5440.
> 
> Changes from v5:
> - Rebase this patchset on next branch of linux-soc-thermal.git
> 

Pulled into my next branch. Thanks.

> Changes from v4:
> - Remove un-necessary triminfo_ctrl_{shift, mask} field
> - Includes Bartlomiej's patch[1] that Exynos5260 / Exynos5420 should not use
> TRIM_RELOAD flag
> [2] https://lkml.org/lkml/2014/8/20/481
> 
> Changes from v3:
> - Add reviewed message of Amit Daniel Kachhap <amit.daniel@samsung.com>
> - Split RELOAD patch as two patch
> - Fix 'TRIMINFO_RELOAD_SHIFT' value
> - This series includes separate patch[1]
> [1] https://lkml.org/lkml/2014/8/20/5
> - Drop ACTIME bit setting because TRM includes not enough information of ACTIME bit.
> 
> Changes from v2:
> - Fix build break because of missing 'or' operation.
> 
> Changes from v1:
> - Add missing 'TMU_SUPPORT_TRIM_RELOAD' features
> 
> Chanwoo Choi (2):
>   thermal: exynos: Add support for many TRIMINFO_CTRL registers
>   thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250
> 
>  drivers/thermal/samsung/exynos_thermal_common.h |  1 +
>  drivers/thermal/samsung/exynos_tmu.c            | 15 ++++++++++++---
>  drivers/thermal/samsung/exynos_tmu.h            |  7 +++++--
>  drivers/thermal/samsung/exynos_tmu_data.c       | 11 +++++++++--
>  drivers/thermal/samsung/exynos_tmu_data.h       |  8 ++++++--
>  5 files changed, 33 insertions(+), 9 deletions(-)
> 
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
