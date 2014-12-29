Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaL2Sin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:38:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55280 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbaL2Sim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:38:42 -0500
Date: Mon, 29 Dec 2014 12:38:40 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gru: cleanup on stack DECLARE_COMPLETION
Message-ID: <20141229183840.GA5792@sgi.com>
References: <1419877876-30308-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419877876-30308-1-git-send-email-der.herr@hofr.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Mon, Dec 29, 2014 at 01:31:16PM -0500, Nicholas Mc Guire wrote:
> fix-up for incorrect use of DECLARE_COMPLETION. see also commit
> 6e9a4738 ("completions: lockdep annotate on stack completions")
> 
> V2: split out patch for individual files and (hopefully) proper
>     labeling this time
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 
> patch was compile tested with defconfig_x86_64 + CONFIG_IRQ_REMAP=y
> CONFIG_X86_X2APIC=y, CONFIG_X86_UV=y, CONFIG_SGI_GRU=y
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/misc/sgi-gru/grukservices.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
> index 913de07..abf2b73 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -1044,7 +1044,7 @@ done:
>  
>  static int quicktest2(unsigned long arg)
>  {
> -	static DECLARE_COMPLETION(cmp);
> +	static DECLARE_COMPLETION_ONSTACK(cmp);
>  	unsigned long han;
>  	int blade_id = 0;
>  	int numcb = 4;
> -- 
> 1.7.10.4
