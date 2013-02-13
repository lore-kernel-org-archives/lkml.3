Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3BMJuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:50:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641Ab3BMJuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:50:03 -0500
Date: Wed, 13 Feb 2013 10:49:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@ingics.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: as3711: Fix checking if no platform initialization
 data
In-Reply-To: <1360719288.14930.5.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1302131049410.18535@axis700.grange>
References: <1360719288.14930.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:YvbagGwMQ3H/h9HLBsdeI+kpwwLaMSgKLBCI7Cri7Eu
 ReRxoxMcVOldySN/pt/Qd3vehJm06wNnqZMB5g1NDA529E1xxM
 KWd4KKUdew/n4+TbqseieJimQEefYrJn3PLx2I08vXeiMSI7Ag
 Vu46DIlWWSHgb5Wq74yfxy//xAsZFG2Ec/1Ia10c4brNZNIloA
 XCj2AZPk4jGEM3u5lPrkf0tWBZcxVQmYtNWKGjqREvoo8k+oH8
 OnDeqraiwiBycp4yKHb5yNmeN9ZK/qT2jeJZZoWQpt82kX19mI
 /x46/EniU7lUdnJGZWjY2QxPjOtQ+kNWlb+gmHoJ8waosFTcRe
 cJIZ5Z8o8v5o8tjRQLJ85U15fpgrBBMHYAwpjRxA5yHjsQm0/7
 NNBzCwqgQiWrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, Axel Lin wrote:

> To skip registering regulator if no platform initialization data,
> we should check reg_data rather than ri->desc.name.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/regulator/as3711-regulator.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index 2f1341d..f0ba8c4 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -303,7 +303,7 @@ static int as3711_regulator_probe(struct platform_device *pdev)
>  		reg_data = pdata ? pdata->init_data[id] : NULL;
>  
>  		/* No need to register if there is no regulator data */
> -		if (!ri->desc.name)
> +		if (!reg_data)
>  			continue;
>  
>  		reg = &regs[id];
> -- 
> 1.7.9.5
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
