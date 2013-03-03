Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3CCUgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:36:32 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:41178 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3CCUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:36:31 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: use config scripts to detect ncurses libs
Date: Sun, 3 Mar 2013 21:36:26 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1362153044-23611-1-git-send-email-jlec@gentoo.org> <1362153044-23611-2-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362153044-23611-2-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303032136.27096.yann.morin.1998@free.fr>
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
> The old heuristic for detection of ncurses libs will be extended to the
> pkg-config and the config scripts.
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> ---
>  scripts/kconfig/lxdialog/check-lxdialog.sh | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
> index 8078813..8086874 100644
> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
> @@ -4,6 +4,12 @@
>  # What library to link
>  ldflags()
>  {
> +	pkg-config --libs ncursesw 2>/dev/null && exit
> +	pkg-config --libs ncurses 2>/dev/null && exit
> +	ncursesw5-config --libs 2>/dev/null && exit
> +	ncurses5-config --libs 2>/dev/null && exit
> +	ncursesw6-config --libs 2>/dev/null && exit
> +	ncurses6-config --libs 2>/dev/null && exit

In the light of the different mails on the subject, it appears that the
ncurses*-config script are unreliable: at least one major distribution
(Debian) is broken and, for various reasons, is not gonna fix it, and
all its derivatives (eg. Ubuntu) do suffer from the same deficiency.

I think we should stick to:
  - try with pkg-config;
  - fallback to the legacy heuristic.

Does using pkg-config fix your use-case?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
