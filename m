Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaG2OMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:12:52 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:53693 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaG2OMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:12:50 -0400
Date: Tue, 29 Jul 2014 10:12:34 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rui.zhang@intel.com, eduardo.valentin@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, javi.merino@arm.com
Subject: Re: [PATCH-REPOST] thermal: of: look for sensor driver parent node
 if device node missing
Message-ID: <20140729141234.GA26807@developer>
References: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Laxman,

On Fri, Jul 25, 2014 at 02:49:31PM +0530, Laxman Dewangan wrote:
> There are some mfd devices which supports junction thermal interrupt
> like ams,AS3722. The DT binding of these devices are defined as the
> flat and drivers for sub module of such devices are registered as
> the mfd_add_devices. In this method, the sub devices registered as
> platform driver and these do not have the of_node pointer on their
> device structure. In this case, use the parent of_node pointer to
> get the required of_node pointer.
> 

Can you please elaborate a bit more on your proposal? So, you would
append the thermal zones on the DT node of the MFD device?

To me looks like MFD becomes sowhat obsolete with DT.

Besides, to what I could see from past iterations, MFD with DT seams to
be a controvertial subject. That is, we have people that agree to have
it, and people that are not fan of it.

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> I typed differnet email ID for Eduardo and so it did not reach to him.
> Resending the patch with correct ID.
> 
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
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
