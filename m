Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaCEKEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:04:15 -0500
Received: from sym2.noone.org ([178.63.92.236]:45450 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbaCEKEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:04:08 -0500
Date: Wed, 5 Mar 2014 11:04:05 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dulshani.gunawardhana89@gmail.com
Subject: Re: [PATCH] staging: cxt1e1: use kzalloc instead of kmalloc/memset
 0
Message-ID: <20140305100405.GG1883@distanz.ch>
References: <1673333.LFj7fBDsDS@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1673333.LFj7fBDsDS@daeseok-laptop.cloud.net>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-05 at 03:37:15 +0100, Daeseok Youn <daeseok.youn@gmail.com> wrote:
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/cxt1e1/sbecom_inline_linux.h |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
> index ba3ff3e..6dd1b55 100644
> --- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
> +++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
> @@ -46,11 +46,9 @@ void        pci_write_32 (u_int32_t *p, u_int32_t v);
>  static inline void *
>  OS_kmalloc (size_t size)
>  {
> -    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
> +	char *ptr = kzalloc(size, GFP_KERNEL | GFP_DMA);
>  
> -    if (ptr)
> -        memset (ptr, 0, size);
> -    return ptr;
> +	return ptr;
>  }

It would probably be even better to get rid of this function altogether
and replace all calls to it by kmalloc/kzalloc.

>From a quick look at the users of OS_kmalloc, it also looks like GFP_DMA
isn't needed for all of them.

Cheers
Tobias
