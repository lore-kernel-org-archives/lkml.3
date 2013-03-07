Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3CGBcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:32:07 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47972 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932234Ab3CGBcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:32:03 -0500
X-Sasl-enc: M0liOeGDxS58riCy3e90ZHzOUsdW5lh8Z4OUbRwN4c0S 1362619921
Date: Thu, 7 Mar 2013 09:31:58 +0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: [PATCH] zcache/debug: compiler failure on PPC64.
Message-ID: <20130307013158.GC2910@kroah.com>
References: <1362615216-12293-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362615216-12293-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 07:13:36PM -0500, Konrad Rzeszutek Wilk wrote:
> On PPC64 we get this:
> In file included from drivers/staging/zcache/debug.c:2:
> drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
> drivers/staging/zcache/debug.h:16: error: implicit declaration of function 'BUG_ON'
> 
> This simple patch adds the appropiate header file to finish
> the compile.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/staging/zcache/debug.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
> index eef67db..0d9c6b4 100644
> --- a/drivers/staging/zcache/debug.h
> +++ b/drivers/staging/zcache/debug.h
> @@ -1,5 +1,6 @@
>  #ifdef CONFIG_ZCACHE_DEBUG
>  
> +#include <linux/bug.h>
>  /* we try to keep these statistics SMP-consistent */

Put the #include files at the top of the file.

Also, you didn't really test this on linux-next as you can't select this
option at the moment, I think you also want to fix that at the same
time, unless you really don't want anyone to ever select this option :)

Try it again?

thanks,

greg k-h
