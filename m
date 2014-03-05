Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaCEKNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:13:25 -0500
Received: from sym2.noone.org ([178.63.92.236]:46232 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaCEKNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:13:23 -0500
Date: Wed, 5 Mar 2014 11:13:21 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        davem@davemloft.net
Subject: Re: [PATCH 7/7] staging: cxt1e1: remove unneeded a value
Message-ID: <20140305101320.GH1883@distanz.ch>
References: <4401309.KAOCJ1Tfb2@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4401309.KAOCJ1Tfb2@daeseok-laptop.cloud.net>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-05 at 02:24:22 +0100, Daeseok Youn <daeseok.youn@gmail.com> wrote:
> 
> It doesn't need to assign name array address to np pointer.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/linux.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
> index 5bb42ae..cae8c66 100644
> --- a/drivers/staging/cxt1e1/linux.c
> +++ b/drivers/staging/cxt1e1/linux.c
> @@ -205,15 +205,14 @@ status_t
>  c4_wq_port_init(mpi_t *pi)
>  {
>  
> -	char        name[16], *np;  /* NOTE: name of the queue limited by system
> +	char        name[16];  /* NOTE: name of the queue limited by system
>  				     * to 10 characters */
>  
>  	if (pi->wq_port)
>  		return 0;                   /* already initialized */
>  
> -	np = name;
>  	memset(name, 0, 16);

This isn't necessary since s{,n}printf() adds a terminating '\0'.

> -	sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
> +	sprintf(name, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */

Better use snprintf() here, even if the comment above claims the name
never to be no longer than 10 characters.

Cheers
Tobias
