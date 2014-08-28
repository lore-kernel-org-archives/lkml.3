Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaH1OxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:53:09 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:57437 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaH1OxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:53:07 -0400
Date: Thu, 28 Aug 2014 10:53:12 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com,
        kgene.kim@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 4/4] thermal: exynos: Remove duplicate code when
 reading triminfo register of Exynos5440
Message-ID: <20140828145310.GC18194@developer>
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
 <1409016665-3824-5-git-send-email-cw00.choi@samsung.com>
 <53FEAF2A.1080400@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FEAF2A.1080400@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 01:25:14PM +0900, Chanwoo Choi wrote:
> Dear Eduardo,
> 
> This patch is wrong. It is my mistake.
> 
> Please ignore only this patch because
> the offset calculation of 'case 0' is different from 'case 2'.


Do patches 1 - 3 are still correct? Patch 1, from Barlomiej, seams to be
a common agreement. 

> 
> Best Regards,
> Chanwoo Choi
> 
> On 08/26/2014 10:31 AM, Chanwoo Choi wrote:
> > This patch remove simply duplicate code when reading triminfo register of Exynos5440.
> > 
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <edubezval@gmail.com>
> > Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index 64c702a..5888467 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -187,15 +187,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  		 */
> >  		switch (data->id) {
> >  		case 0:
> > +		case 2:
> >  			trim_info = readl(data->base +
> >  			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> >  			break;
> >  		case 1:
> >  			trim_info = readl(data->base + reg->triminfo_data);
> >  			break;
> > -		case 2:
> > -			trim_info = readl(data->base -
> > -			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> >  		}
> >  	} else {
> >  		/* On exynos5420 the triminfo register is in the shared space */
> > 
> 
