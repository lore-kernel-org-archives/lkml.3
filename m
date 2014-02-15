Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaBORQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:16:32 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51855 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaBORQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:16:31 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 15 Feb 2014 09:16:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Archana kumari <archanakumari959@gmail.com>,
        David Binderman <dcb314@hotmail.com>
Subject: Re: [PATCH] staging: davinci_vpfe: fix error check
Message-ID: <20140215171619.GA22985@leaf>
References: <1392459431-28203-1-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392459431-28203-1-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 11:17:11AM +0100, Levente Kurusa wrote:
> The check would check the pointer, which is never less than 0.
> According to the error message, the correct check would be
> to check the return value of ipipe_mode. Check that instead.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Levente Kurusa <levex@linux.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> index 2d36b60..b2daf5e 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> @@ -267,7 +267,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
>  	}
>  
>  	ipipe_mode = get_ipipe_mode(ipipe);
> -	if (ipipe < 0) {
> +	if (ipipe_mode < 0) {
>  		pr_err("Failed to get ipipe mode");
>  		return -EINVAL;
>  	}
> -- 
> 1.8.3.1
> 
