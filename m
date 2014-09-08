Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaIHWjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:39:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39753 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaIHWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:39:10 -0400
Date: Tue, 9 Sep 2014 01:38:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hugues <morisset.hugues@gmail.com>, Oleg Drokin <oleg.drokin@intel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
Message-ID: <20140908223853.GN6600@mwanda>
References: <540E27FB.2070206@gmail.com>
 <540E287D.5090101@gmail.com>
 <540E28AD.2060607@gmail.com>
 <540E29B1.6090005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540E29B1.6090005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:12:01AM +0200, Hugues wrote:
> Fix potential buffer underflow
> 
> When the string 'name' start with a '-' ptr == name and so --ptr will
> underflow, this patch corrected this by checking ptr before decrementing.

Good eye.  Please fix up the changelog and send it inline etc and
resend.  I've added Oleg and Andreas to the CC list so that this doesn't
get lost.

regards,
dan carpenter

> >From 5786040323bd1dc3149fb4afbea9f01e2bf4cfdf Mon Sep 17 00:00:00 2001
> From: Hugues Morisset <morisset.hugues@gmail.com>
> Date: Mon, 8 Sep 2014 22:59:04 +0200
> Subject: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
> 
> Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
> ---
>  drivers/staging/lustre/lustre/include/obd.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
> index 409eae6..bb67e40 100644
> --- a/drivers/staging/lustre/lustre/include/obd.h
> +++ b/drivers/staging/lustre/lustre/include/obd.h
> @@ -677,7 +677,12 @@ static inline int is_osp_on_mdt(char *name)
>  	if (strncmp(ptr + 1, "MDT", 3) != 0)
>  		return 0;
>  
> -	while (*(--ptr) != '-' && ptr != name);
> +	if (ptr == name)
> +		return 0;
> +
> +	--ptr;
> +	while (ptr != '-' && ptr != name)
> +		--ptr;
>  
>  	if (ptr == name)
>  		return 0;
> -- 
> 2.1.0
> 

> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

