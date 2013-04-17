Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966772Ab3DQPg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:36:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:56722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3DQPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,494,1363158000"; 
   d="scan'208";a="296379296"
Message-ID: <1366212981.2091.67.camel@rzhang1-mobl4>
Subject: Re: [PATCH RESEND 01/11] thermal: use strlcpy instead of strcpy
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 23:36:21 +0800
In-Reply-To: <1365437258-31412-2-git-send-email-eduardo.valentin@ti.com>
References: <1365437258-31412-1-git-send-email-eduardo.valentin@ti.com>
	 <1365437258-31412-2-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 12:07 -0400, Eduardo Valentin wrote:
> For memory boundaries safety, use strlcpy instead of strcpy.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

ACK.

thanks,
rui
> ---
>  drivers/thermal/thermal_sys.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5b7863a..7875607 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1289,7 +1289,7 @@ thermal_cooling_device_register(char *type, void *devdata,
>  		return ERR_PTR(result);
>  	}
>  
> -	strcpy(cdev->type, type ? : "");
> +	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
>  	mutex_init(&cdev->lock);
>  	INIT_LIST_HEAD(&cdev->thermal_instances);
>  	cdev->ops = ops;
> @@ -1594,7 +1594,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>  		return ERR_PTR(result);
>  	}
>  
> -	strcpy(tz->type, type ? : "");
> +	strlcpy(tz->type, type ? : "", sizeof(tz->type));
>  	tz->ops = ops;
>  	tz->tzp = tzp;
>  	tz->device.class = &thermal_class;


