Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaGVCIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:08:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaGVCIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:08:07 -0400
Date: Mon, 21 Jul 2014 19:08:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        oleg.drokin@intel.com, jinshan.xiong@intel.com, lai.siyao@intel.com,
        joe@perches.com, bergwolf@gmail.com, john.hammond@intel.com,
        sachin.kamat@linaro.org
Subject: Re: [PATCH] staging: llite: rw.c: use gfp_t to store GFP flags
Message-ID: <20140722020805.GA19215@kroah.com>
References: <22be101821a4af2c92ca597832cbb720c655418e.1405990074.git.guillaume@morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22be101821a4af2c92ca597832cbb720c655418e.1405990074.git.guillaume@morinfr.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:57:57AM +0200, Guillaume Morin wrote:
> Use gfp_t to store GPF_* flags instead of unsigned int. 
> This was reported by sparse.
> 
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> ---
>  drivers/staging/lustre/lustre/llite/rw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
> index 5616210..3554272 100644
> --- a/drivers/staging/lustre/lustre/llite/rw.c
> +++ b/drivers/staging/lustre/lustre/llite/rw.c
> @@ -496,7 +496,7 @@ static int ll_read_ahead_page(const struct lu_env *env, struct cl_io *io,
>  	struct cl_object *clob  = ll_i2info(mapping->host)->lli_clob;
>  	struct cl_page   *page;
>  	enum ra_stat      which = _NR_RA_STAT; /* keep gcc happy */
> -	unsigned int      gfp_mask;
> +	gfp_t             gfp_mask;

Odd thing is, that function doesn't seem to even use that variable
anywhere...  Can you just remove it entirely?

thanks,

greg k-h
