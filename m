Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab3B0TDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:03:07 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41672 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3B0TDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:03:05 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Use config scripts to detect ncurses libs for nconfig
Date: Wed, 27 Feb 2013 20:02:59 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1361988458-18486-1-git-send-email-jlec@gentoo.org> <1361988458-18486-2-git-send-email-jlec@gentoo.org>
In-Reply-To: <1361988458-18486-2-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302272002.59833.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Wednesday 27 February 2013 jlec@gentoo.org wrote:
> From: Justin Lecher <jlec@gentoo.org>
> 
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so.
> 
> Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
> This patch makes use of it to detect the necessary libs for linking of the
> ncurses nconfig dialog.
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>

Ditto for the subject, as for your previous patch.

> ---
>  scripts/kconfig/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 3091794..7ddbf98 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -216,7 +216,7 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>  
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>  
> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> +HOSTLOADLIBES_nconf	= -lmenu -lpanel `ncursesw5-config --libs 2>/dev/null || ncurses5-config --libs 2>/dev/null`

Long-line. Also, this expands the `...` in the shell, not in the Makefile.
I'd rather have the expansion be done by the Makefile:

HOSTLOADLIBES_nconf	= -lmenu -lpanel
HOSTLOADLIBES_nconf	+= $(shell    ncursesw5-config --libs 2>/dev/null \
				   || ncurses5-config --libs 2>/dev/null  )

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
