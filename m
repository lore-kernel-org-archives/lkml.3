Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3CCUie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:38:34 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64803 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3CCUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:38:33 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
Date: Sun, 3 Mar 2013 21:38:29 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1362153044-23611-1-git-send-email-jlec@gentoo.org> <1362153044-23611-3-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362153044-23611-3-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303032138.29138.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Friday 01 March 2013 jlec@gentoo.org wrote:
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so. Ncurses provides a config script
> (ncurses5-config) or in very recent version even a pkg-config module to assist
> finding ncurses.
> 
> This patch makes use of it to detect the necessary libs for linking of the
> ncurses nconfig dialog
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> ---
>  scripts/kconfig/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 231b475..cc81db5 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -219,7 +219,11 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>  
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>  
> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> +HOSTLOADLIBES_nconf	= -lmenu -lpanel
> +HOSTLOADLIBES_nconf	+= $(shell \
> +				pkg-config --libs ncurses 2>/dev/null \
> +				|| ncurses5-config --libs 2>/dev/null \
> +				|| ncurses6-config --libs 2>/dev/null  )

Ditto as for menuconfig: drop the ncurses*-config scripts, and:
  - try pkg-config;
  - fallback to -lncurses.

HOSTLOADLIBES_nconf	+= $(shell \
				pkg-config --libs ncurses 2>/dev/null \
				|| echo -lncurses )

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
