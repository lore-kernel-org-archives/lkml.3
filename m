Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbaGYJal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:30:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57407 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaGYJak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:30:40 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Fri, 25 Jul 2014 10:30:36 +0100
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-REPOST] thermal: of: look for sensor driver parent node
 if device node missing
Message-ID: <20140725093036.GB2865@e104805>
References: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1406279971-14957-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Jul 2014 09:30:36.0754 (UTC) FILETIME=[17539320:01CFA7EB]
X-MC-Unique: 114072510303800201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixed Eduardo's email *again*]

On Fri, Jul 25, 2014 at 10:19:31AM +0100, Laxman Dewangan wrote:
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
> 

