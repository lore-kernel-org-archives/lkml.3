Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaCaHZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:25:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41181 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaCaHZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:25:09 -0400
Date: Mon, 31 Mar 2014 09:25:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/UV: Fix conditional in gru_exit
Message-ID: <20140331072505.GA2004@gmail.com>
References: <20140320203646.GA603@sgi.com>
 <20140321075549.GB23556@gmail.com>
 <20140321161342.GA17081@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321161342.GA17081@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Fri, Mar 21, 2014 at 08:55:49AM +0100, Ingo Molnar wrote:
> > > -	if (!is_uv_system())
> > > +	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
> > >  		return;
> > 
> > Such an amalgation of three system specific conditionals is 
> > disgusting, please at minimum factor out a helper routine so that such 
> > mismatches cannot happen.
> >
> Agreed.  Here's a new patch.
> 
> 
> Fix supported system conditional in gru_exit.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  drivers/misc/sgi-gru/grufile.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/misc/sgi-gru/grufile.c
> ===================================================================
> --- linux.orig/drivers/misc/sgi-gru/grufile.c
> +++ linux/drivers/misc/sgi-gru/grufile.c
> @@ -58,6 +58,10 @@ static int max_user_cbrs, max_user_dsr_b
>  
>  static struct miscdevice gru_miscdev;
>  
> +static int gru_unsupported(void)
> +{
> +	return !is_uv_system() || (is_uvx_hub() && !is_uv2_hub());
> +}

So the usual pattern is to introduce simple patterns, without logic 
operations in their name. I.e. "gru_supported()" would be more natural 
than "gru_not_supported()" or gru_unsupported()".

Thanks,

	Ingo
