Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaJPS0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:26:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49793 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJPSZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:25:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+PNJfQJ7S+lGMZk3sv1McPdMGrFaOelZM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 85A0A600981
Date: Thu, 16 Oct 2014 14:25:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] char: hw_random: core.c:  Changed from using
 strncat to strlcat
Message-ID: <20141016182543.GP17447@titan.lakedaemon.net>
References: <1413483355-29650-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413483355-29650-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 08:15:55PM +0200, Rickard Strandqvist wrote:
> The buf is used to hold the list of hwrng devices registered.
> The old code ensures we don't walk off the end of buf as we
> fill it, but it's unnecessarily complicated and thus difficult
> to maintain. Simplify it by using strlcat.

> We also ensure the string within buf is NULL terminated
> so the final strlen is ok.

This text is no longer necessary.

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Please add my:

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

to the next version of this patch.  It makes the maintainers job a *lot*
easier not having to sift through old threads collecting up all the
tags.

thx,

Jason.

> ---
>  drivers/char/hw_random/core.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index aa30a25..25599ea 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -281,7 +281,7 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>  					 char *buf)
>  {
>  	int err;
> -	ssize_t ret = 0;
> +	ssize_t ret;
>  	struct hwrng *rng;
>  
>  	err = mutex_lock_interruptible(&rng_mutex);
> @@ -289,13 +289,10 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>  		return -ERESTARTSYS;
>  	buf[0] = '\0';
>  	list_for_each_entry(rng, &rng_list, list) {
> -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> -		ret += strlen(rng->name);
> -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> -		ret++;
> +		strlcat(buf, rng->name, PAGE_SIZE);
> +		strlcat(buf, " ", PAGE_SIZE);
>  	}
> -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> -	ret++;
> +	ret = strlcat(buf, "\n", PAGE_SIZE);
>  	mutex_unlock(&rng_mutex);
>  
>  	return ret;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
