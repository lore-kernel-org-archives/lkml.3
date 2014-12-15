Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbaLOKfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:35:05 -0500
Received: from zimbra.brainity.com ([188.40.76.72]:58056 "EHLO
	zimbra.brainity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaLOKfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:35:02 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 05:35:01 EST
Date: Mon, 15 Dec 2014 11:27:36 +0100 (CET)
From: Daniel Walter <sahne@0x90.at>
To: Richard Weinberger <richard@nod.at>
Cc: arnd@arndb.de, miklos@szeredi.hu, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, lftan@altera.com,
        user-mode-linux-devel@lists.sourceforge.net
Message-ID: <1164899144.1350.1418639256356.JavaMail.root@0x90.at>
In-Reply-To: <1418216535-29295-1-git-send-email-richard@nod.at>
Subject: Re: [uml-devel] [PATCH] um: Skip futex_atomic_cmpxchg_inatomic()
 test
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.155.151.233]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC38 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Richard Weinberger" <richard@nod.at>
> To: user-mode-linux-devel@lists.sourceforge.net
> Cc: arnd@arndb.de, miklos@szeredi.hu, "Richard Weinberger" <richard@nod.at>, linux-kernel@vger.kernel.org,
> geert@linux-m68k.org, lftan@altera.com
> Sent: Wednesday, December 10, 2014 1:02:15 PM
> Subject: [uml-devel] [PATCH] um: Skip futex_atomic_cmpxchg_inatomic() test
> 
> futex_atomic_cmpxchg_inatomic() does not work on UML because
> it triggers a copy_from_user() in kernel context.
> On UML copy_from_user() can only be used if the kernel was called
> by a real user space process such that UML can use ptrace()
> to fetch the value.
> 
> Reported-by: Miklos Szeredi <miklos@szeredi.hu>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/Kconfig.common | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
> index 87bc868..d195a87 100644
> --- a/arch/um/Kconfig.common
> +++ b/arch/um/Kconfig.common
> @@ -3,6 +3,7 @@ config UML
>  	default y
>  	select HAVE_ARCH_AUDITSYSCALL
>  	select HAVE_UID16
> +	select HAVE_FUTEX_CMPXCHG if FUTEX
>  	select GENERIC_IRQ_SHOW
>  	select GENERIC_CPU_DEVICES
>  	select GENERIC_IO
> --
> 2.1.0
> 
Hi,

tested it a few days, looks good.


Tested-by: Daniel Walter <d.walter@0x90.at>
