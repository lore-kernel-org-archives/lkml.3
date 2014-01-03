Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaACFdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:33:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:34670 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaACFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:33:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="scan'208";a="459444976"
Date: Thu, 2 Jan 2014 21:38:17 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: fix the wrong return value
Message-ID: <20140103053817.GA3403@psi-dev26.jf.intel.com>
References: <1388719316-5702-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388719316-5702-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 11:21:56AM +0800, Hayes Wang wrote:
> The return value should be the boolean value, not the error code.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/usb/r8152.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index e3d878c..13fabbb 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -2708,7 +2708,7 @@ static bool rtl_ops_init(struct r8152 *tp, const struct usb_device_id *id)
>  			ops->unload		= rtl8153_unload;
>  			break;
>  		default:
> -			ret = -EFAULT;
> +			ret = false;

How about fix the function's return type instead?
Returning bool for success/error in Linux kernel is not natural. You
gotta check rtl_ops_init() for success and !rtl_ops_init() for error.
And you are unable to return the error value.

Br, David

>  			break;
>  		}
>  		break;
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
