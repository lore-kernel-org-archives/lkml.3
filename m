Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239Ab3DCOrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:47:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761228Ab3DCOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:47:08 -0400
Date: Wed, 3 Apr 2013 15:47:02 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Richard Guy Briggs'" <rbriggs@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.8-stable] thermal: return an error on failure to
 register thermal
Message-ID: <20130403144702.GB3047@hercules>
References: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:38:55AM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

I believe this is applicable to all the other stable kernels.

Cheers,
--
Luis

> 
> ------------------
> 
> From: "Richard Guy Briggs <rbriggs@redhat.com>"
> 
> commit da28d966f6aa942ae836d09729f76a1647932309 upstream.
> 
> The return code from the registration of the thermal class is used to
> unallocate resources, but this failure isn't passed back to the caller of
> thermal_init.  Return this failure back to the caller.
> 
> This bug was introduced in changeset 4cb18728 which overwrote the return
> code
> when the variable was re-used to catch the return code of the registration
> of
> the genetlink thermal socket family.
> 
> Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 6472e7e..1a19a2f 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1875,6 +1875,7 @@ static int __init thermal_init(void)
>  		idr_destroy(&thermal_cdev_idr);
>  		mutex_destroy(&thermal_idr_lock);
>  		mutex_destroy(&thermal_list_lock);
> +		return result;
>  	}
>  	result = genetlink_init();
>  	return result;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
