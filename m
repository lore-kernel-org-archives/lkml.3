Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3CFUrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:47:36 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42207 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3CFUrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:47:35 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: optionally use pkg-config to detect ncurses libs
Date: Wed, 6 Mar 2013 21:47:29 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.2-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs> <1362574922-4799-1-git-send-email-jlec@gentoo.org> <1362574922-4799-3-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362574922-4799-3-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303062147.29918.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Wednesday 06 March 2013 jlec@gentoo.org wrote:
> From: Justin Lecher <jlec@gentoo.org>
> 
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so.
> 
> The ncurses pkg-config module will be used to detect the necessary libs for
> linking. If not available the old way of directly specifying libs will be
> used.
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> ---
>  scripts/kconfig/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 231b475..e76ae5d 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -219,7 +219,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>  
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>  
> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> +HOSTLOADLIBES_nconf	= $(shell \
> +				pkg-config --libs menu panel ncurses 2>/dev/null \
> +				|| echo "-lmenu -lpanel -ncurses"  )

Typo: this should be:  "-lncurses"  and not:  "-ncurses"

I'll fix it here before queuing, no need to resend.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
