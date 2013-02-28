Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3B1SQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:16:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51224 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab3B1SQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:16:06 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] menuconfig: use config scripts to detect ncurses libs
Date: Thu, 28 Feb 2013 19:16:00 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1362052335-17913-1-git-send-email-jlec@gentoo.org>
In-Reply-To: <1362052335-17913-1-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302281916.00257.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Thursday 28 February 2013 jlec@gentoo.org wrote:
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so. Ncurses provides a config script
> (ncurses5-config) to assist finding ncurses.
> 
> This patch replaces the old heuristic for detection of ncurses libs for
> linking the ncurses menuconfig dialog by the use of the config scripts.
> This results in the requirement of ncurses version 5.6 or newer for menuconfig.

As you said, ncurses started bundling these files with ncurses-5.6,
which was released in 2006.

OTOH, RHEL4 is still a widely used distro, and was released in 2005,
so is using an ncurses older than 5.6, so I'm afraid we can't drop
the legacy code like that.

Of course, I'm no authority on the subject, so I'd suggest that you
split this patch in two, and re-submit:
  - one patch to add usage of ncurses{w,}5-config;
  - one patch to drop legacy code.

That way, it is easy to apply the *-config part, and get more people
involved in commenting the legacy drop without further delaying use
of the *-config scripts.

And, sorry, I should have been more explicit in my previous mail that
the legacy drop should be in its own patch. I thought that was obvious,
following the "one single change per patch" philosophy.

Thanks you! :-)

Regards,
Yann E. MORIN.

> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> ---
>  scripts/kconfig/lxdialog/check-lxdialog.sh | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
> index c8e8a71..10df55b 100644
> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
> @@ -4,15 +4,8 @@
>  # What library to link
>  ldflags()
>  {
> -	for ext in so a dll.a dylib ; do
> -		for lib in ncursesw ncurses curses ; do
> -			$cc -print-file-name=lib${lib}.${ext} | grep -q /
> -			if [ $? -eq 0 ]; then
> -				echo "-l${lib}"
> -				exit
> -			fi
> -		done
> -	done
> +	ncursesw5-config --libs 2>/dev/null && exit
> +	ncurses5-config --libs 2>/dev/null && exit
>  	exit 1
>  }
>  
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
