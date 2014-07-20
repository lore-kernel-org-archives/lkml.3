Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaGTExR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:53:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37556 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaGTExQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:53:16 -0400
Date: Sun, 20 Jul 2014 07:52:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Cc: gregkh@linuxfoundation.org, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: lustre/lustre/lov: Remove unneeded 'if'
 statement in lov_request.c/lov_check_set()
Message-ID: <20140720045253.GK25880@mwanda>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
 <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 09:34:56PM +0200, Riccardo Lucchese wrote:
> It is silly to go through an if statement to set a single boolean
> value in function of a single boolean expression. In the function
> lov_check_set, assign the return value directly.
> 
> Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
> ---
>  drivers/staging/lustre/lustre/lov/lov_request.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
> index ce830e4..90fc66a 100644
> --- a/drivers/staging/lustre/lustre/lov/lov_request.c
> +++ b/drivers/staging/lustre/lustre/lov/lov_request.c
> @@ -140,14 +140,13 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
>  
>  static int lov_check_set(struct lov_obd *lov, int idx)
>  {
> -	int rc = 0;
> +	int rc;
>  	mutex_lock(&lov->lov_lock);
>  
> -	if (lov->lov_tgts[idx] == NULL ||
> -	    lov->lov_tgts[idx]->ltd_active ||
> -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> -		rc = 1;
> +	rc = lov->lov_tgts[idx] == NULL ||
> +		lov->lov_tgts[idx]->ltd_active ||
> +		(lov->lov_tgts[idx]->ltd_exp != NULL &&
> +		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);

I don't see how this makes the code more readable at all.

regards,
dan carpenter

