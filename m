Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063Ab3GSSoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:44:22 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760859Ab3GSSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:44:20 -0400
Message-ID: <51E988FF.9010201@nod.at>
Date: Fri, 19 Jul 2013 20:44:15 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.07.2013 20:20, schrieb Ramkumar Ramachandra:
> The default configuration dictates that um Linux will launch xterms
> connected to various tty devices on the host.  It makes more sense to
> connect to /dev/pts/N, so that the host can:
> 
>   $ screen /dev/pts/N
> 
> or
> 
>   $ minicom /dev/pts/N
> 
> to start talking to the guest session.  Note that
> con0 (CONFIG_CON_ZERO_CHAN) still defaults to "fd:0,fd:1", printing boot
> messages on the same terminal.

Makes sense. Queued for 3.12.

Thanks,
//richard

> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  Further, I will patch systemd to getty on con0 when um Linux is
>  detected.  Thanks for all the help, and sorry I took so long to
>  figure it out.
> 
>  Applies on top of the patch I sent earlier.
> 
>  arch/um/configs/i386_defconfig   | 2 +-
>  arch/um/configs/x86_64_defconfig | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/configs/i386_defconfig b/arch/um/configs/i386_defconfig
> index 995aecd..74d8823 100644
> --- a/arch/um/configs/i386_defconfig
> +++ b/arch/um/configs/i386_defconfig
> @@ -278,7 +278,7 @@ CONFIG_TTY_CHAN=y
>  CONFIG_XTERM_CHAN=y
>  # CONFIG_NOCONFIG_CHAN is not set
>  CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
> -CONFIG_CON_CHAN="xterm"
> +CONFIG_CON_CHAN="pts"
>  CONFIG_SSL_CHAN="pts"
>  CONFIG_UML_SOUND=m
>  CONFIG_SOUND=m
> diff --git a/arch/um/configs/x86_64_defconfig b/arch/um/configs/x86_64_defconfig
> index f2c6123..7d4cbbf 100644
> --- a/arch/um/configs/x86_64_defconfig
> +++ b/arch/um/configs/x86_64_defconfig
> @@ -270,7 +270,7 @@ CONFIG_TTY_CHAN=y
>  CONFIG_XTERM_CHAN=y
>  # CONFIG_NOCONFIG_CHAN is not set
>  CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
> -CONFIG_CON_CHAN="xterm"
> +CONFIG_CON_CHAN="pts"
>  CONFIG_SSL_CHAN="pts"
>  CONFIG_UML_SOUND=m
>  CONFIG_SOUND=m
> 

