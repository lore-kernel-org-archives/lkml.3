Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab3BSPtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:49:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:12219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab3BSPtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:49:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="264592329"
Message-ID: <1361288936.2323.31.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: return an error on failure to register thermal
 class
From: Zhang Rui <rui.zhang@intel.com>
To: Richard Guy Briggs <rbriggs@redhat.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Feb 2013 23:48:56 +0800
In-Reply-To: <1360697984-19960-1-git-send-email-rbriggs@redhat.com>
References: <1360697984-19960-1-git-send-email-rbriggs@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 14:39 -0500, Richard Guy Briggs wrote:
> The return code from the registration of the thermal class is used to
> unallocate resources, but this failure isn't passed back to the caller of
> thermal_init.  Return this failure back to the caller.
> 
> This bug was introduced in changeset 4cb18728 which overwrote the return code
> when the variable was re-used to catch the return code of the registration of
> the genetlink thermal socket family.
> 
> Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>

applied to thermal  -next.

thanks,
rui
> ---
>  drivers/thermal/thermal_sys.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 8c8ce80..bfbf9fb 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1807,6 +1807,7 @@ static int __init thermal_init(void)
>  		idr_destroy(&thermal_cdev_idr);
>  		mutex_destroy(&thermal_idr_lock);
>  		mutex_destroy(&thermal_list_lock);
> +		return result;
>  	}
>  	result = genetlink_init();
>  	return result;


