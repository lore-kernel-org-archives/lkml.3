Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab3CYGXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:23:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:58850 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab3CYGXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,902,1355126400"; 
   d="scan'208";a="307875235"
Message-ID: <1364192605.2465.18.camel@rzhang1-mobl4>
Subject: Re: [PATCH 2/2] staging: ti-soc-thermal: remove external heat while
 extrapolating hotspot
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 14:23:25 +0800
In-Reply-To: <1363986787-28147-3-git-send-email-eduardo.valentin@ti.com>
References: <1363986787-28147-1-git-send-email-eduardo.valentin@ti.com>
	 <1363986787-28147-3-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 17:13 -0400, Eduardo Valentin wrote:
> For boards that provide a PCB sensor close to SoC junction
> temperature, it is possible to remove the cumulative heat
> reported by the SoC temperature sensor.
> 
> This patch changes the extrapolation computation to consider
> an external sensor in the extrapolation equations.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/staging/ti-soc-thermal/ti-thermal-common.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
> index 231c549..52d3c1b 100644
> --- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
> +++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
> @@ -92,10 +92,9 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
>  	if (ret)
>  		return ret;
>  
> -	pcb_temp = 0;
> -	/* TODO: Introduce pcb temperature lookup */
> +	ret = thermal_zone_lookup_temperature("pcb", &pcb_temp);
>  	/* In case pcb zone is available, use the extrapolation rule with it */
> -	if (pcb_temp) {
> +	if (!ret) {
>  		tmp -= pcb_temp;
>  		slope = s->slope_pcb;
>  		constant = s->constant_pcb;

I can not see this piece of code.
But I assume that the thermal_zone_device is registered in another
driver, right?
or else you can use the thermal_zone_device pointer directly instead.

thanks,
rui

