Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3EaM1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:27:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46759 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3EaM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:27:08 -0400
Date: Fri, 31 May 2013 15:26:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] agp: info leak in agpioc_info_wrap()
Message-ID: <20130531122658.GT23987@mwanda>
References: <20130413091611.GA11215@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413091611.GA11215@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

regards,
dan carpenter

On Sat, Apr 13, 2013 at 12:16:11PM +0300, Dan Carpenter wrote:
> On 64 bit systems the agp_info struct has a hole between ->agp_mode and
> ->aper_base.  We need to clear it to avoid leaking stack information to
> userspace.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
> index 2e04433..3fbce33 100644
> --- a/drivers/char/agp/frontend.c
> +++ b/drivers/char/agp/frontend.c
> @@ -729,6 +729,7 @@ static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
>  
>  	agp_copy_info(agp_bridge, &kerninfo);
>  
> +	memset(&userinfo, 0, sizeof(userinfo));
>  	userinfo.version.major = kerninfo.version.major;
>  	userinfo.version.minor = kerninfo.version.minor;
>  	userinfo.bridge_id = kerninfo.device->vendor |
