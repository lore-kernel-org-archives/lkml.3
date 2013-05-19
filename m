Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3ESSat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 14:30:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3ESSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 14:30:47 -0400
Date: Sun, 19 May 2013 21:30:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] gru: fix a sanity test in gru_set_context_option()
Message-ID: <20130519183041.GB30128@mwanda>
References: <20130519125950.GA17651@elgon.mountain>
 <20130519144442.GA8926@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130519144442.GA8926@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 09:44:42AM -0500, Dimitri Sivanich wrote:
> 
> Since we're here, maybe we should neaten this up a little?
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  drivers/misc/sgi-gru/grufault.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/misc/sgi-gru/grufault.c
> ===================================================================
> --- linux.orig/drivers/misc/sgi-gru/grufault.c
> +++ linux/drivers/misc/sgi-gru/grufault.c
> @@ -876,8 +876,9 @@ int gru_set_context_option(unsigned long
>  	switch (req.op) {
>  	case sco_blade_chiplet:
>  		/* Select blade/chiplet for GRU context */
> -		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
> -		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
> +		if (req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB ||
> +			req.val1 < -1 || req.val1 >= GRU_MAX_BLADES ||
> +			(req.val1 >= 0 && !gru_base[req.val1])) {
>  			ret = -EINVAL;

I generally prefer how in the original code all the sub conditions
were aligned nicely but I will Ack your version as well.  Thanks.

regards,
dan carpenter

>  		} else {
>  			gts->ts_user_blade_id = req.val1;
