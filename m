Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaLDJTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:19:31 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:35761 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbaLDJT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:19:27 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, shawn.guo@linaro.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] video: fsl-dcfb: Add dcfb framebuffer driver for LS1021A platform
Date: Thu, 04 Dec 2014 10:21:32 +0100
Message-ID: <3011460.gQ3SqeWtnL@ws-stein>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1417598162-40433-2-git-send-email-Li.Xiubo@freescale.com>
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com> <1417598162-40433-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 17:15:59, Xiubo Li wrote:
> +	tnp = of_find_node_by_name(dnp, "display-timings");
> +	if (!tnp) {
> +		dev_err(dcfb->dev, "failed to find \"display-timings\" node\n");
> +		return -ENODEV;
> +		goto put_dnp;
> +	}
> +
> +	for (i = 0; i < of_get_child_count(tnp); i++) {
> +		struct videomode vm;
> +
> +		ret = videomode_from_timings(timings, &vm, i);
> +		if (ret < 0)
> +			goto put_tnp;
> +
> +		ret = fb_videomode_from_videomode(&vm, &fb_vm);
> +		if (ret < 0)
> +			goto put_tnp;
> +
> +		fb_add_videomode(&fb_vm, &info->modelist);
> +	}
> +
> +	ret = of_get_fb_videomode(dnp, &fb_vm, OF_USE_NATIVE_MODE);
> +	if (ret)
> +		goto put_dnp;

Souldn't this be put_tnp like in the loop above? 

> +	fb_videomode_to_var(&info->var, &fb_vm);
> +	ret = fsl_dcfb_check_var(&info->var, info);

But picking the native mode per default looks nice to be! :)

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082

