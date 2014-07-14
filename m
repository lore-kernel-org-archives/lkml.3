Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaGNMG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:06:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaGNMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:06:49 -0400
Message-ID: <1405339495.4627.3.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if
 device node missing
From: Lucas Stach <l.stach@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2014 14:04:55 +0200
In-Reply-To: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 14.07.2014, 16:42 +0530 schrieb Laxman Dewangan:
> There are some mfd devices which supports junction thermal interrupt
> like ams,AS3722. The DT binding of these devices are defined as the
> flat and drivers for sub module of such devices are registered as
> the mfd_add_devices. In this method, the sub devices registered as
> platform driver and these do not have the of_node pointer on their
> device structure. In this case, use the parent of_node pointer to
> get the required of_node pointer.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/thermal/of-thermal.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 04b1be7..85a7d71 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -396,6 +396,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>  		return ERR_PTR(-EINVAL);
>  
>  	sensor_np = dev->of_node;
> +	if (!sensor_np && dev->parent)
> +		sensor_np = dev->parent->of_node;
>  
>  	for_each_child_of_node(np, child) {
>  		struct of_phandle_args sensor_specs;

This seems like the wrong way around. If the MFD has subdev information
stored in the parent node it should be the MFD drivers responsibility to
populate the subdev of_node with its own node. The subdev should not be
forced to make such possible unsafe assumptions.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

