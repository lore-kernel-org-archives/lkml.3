Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab3DIDcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:32:00 -0400
Received: from ozlabs.org ([203.10.76.45]:33784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762581Ab3DIDb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:31:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Cohen <david.a.cohen@intel.com>, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>
Subject: Re: [PATCH] MODSIGN: do not send garbage to stderr when enabling modules signature
In-Reply-To: <1365457436-5753-1-git-send-email-david.a.cohen@intel.com>
References: <1365457436-5753-1-git-send-email-david.a.cohen@intel.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 09 Apr 2013 12:57:53 +0930
Message-ID: <87mwt88jt2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Cohen <david.a.cohen@intel.com> writes:
> openssl may send garbage to stderr when generating X.509 key pair for
> modules signature regardless there was an error or not. It makes more
> difficult to create scripts based on kernel error/warning messages.
> This patch makes sure openssl logs go to default stdout.
>
> Signed-off-by: David Cohen <david.a.cohen@intel.com>

Can you please give an example of the "garbage" in your commit message,
or is it binary?

Thanks,
Rusty,.

> ---
>  kernel/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index bbde5f1..5a51e6c 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.genkey
>  	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
>  		-batch -x509 -config x509.genkey \
>  		-outform DER -out signing_key.x509 \
> -		-keyout signing_key.priv
> +		-keyout signing_key.priv 2>&1
>  	@echo "###"
>  	@echo "### Key pair generated."
>  	@echo "###"
> -- 
> 1.7.10.4
