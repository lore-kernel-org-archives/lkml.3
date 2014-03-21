Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbaCUHzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:55:55 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40560 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935AbaCUHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:55:54 -0400
Date: Fri, 21 Mar 2014 08:55:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/UV: Fix conditional in gru_exit
Message-ID: <20140321075549.GB23556@gmail.com>
References: <20140320203646.GA603@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320203646.GA603@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Fix conditional in gru_exit to match gru_init.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  drivers/misc/sgi-gru/grufile.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/misc/sgi-gru/grufile.c
> ===================================================================
> --- linux.orig/drivers/misc/sgi-gru/grufile.c
> +++ linux/drivers/misc/sgi-gru/grufile.c
> @@ -573,7 +573,7 @@ exit0:
>  
>  static void __exit gru_exit(void)
>  {
> -	if (!is_uv_system())
> +	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
>  		return;

Such an amalgation of three system specific conditionals is 
disgusting, please at minimum factor out a helper routine so that such 
mismatches cannot happen.

Thanks,

	Ingo
