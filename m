Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3ALRZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:25:38 -0500
Received: from ares07.inai.de ([5.9.24.206]:53363 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab3ALRZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:25:37 -0500
Date: Sat, 12 Jan 2013 18:25:33 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kconfig-frontends-3.6.0-0 released
In-Reply-To: <201210061755.07330.yann.morin.1998@free.fr>
Message-ID: <alpine.LNX.2.01.1301121818330.15558@nerf07.vanv.qr>
References: <201210061755.07330.yann.morin.1998@free.fr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2012-10-06 17:55, Yann E. MORIN wrote:

>Hello All!
>
>I'm pleased to announce the release of kconfig-frontends 3.6.0-0!
>Go download it there:
>    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.6.0-0.tar.xz

Please stick to a single separator, i.e. "3.6.0.0". The dash is already
used by distributions to mark same-source releases.


>And the repository can be browsed or hg-cloned from:
>  http://ymorin.is-a-geek.org/hg/kconfig-frontends

Ugh, hg. There goes any chance for contributions.


bootstrap.sh
>printf "Running libtoolize...\n"
>libtoolize --copy --force
>printf "Running aclocal...\n"
>aclocal -Wall --force

Not again. autoreconf has existed for so long, why are people still 
hand-coding the boilerplate?


configure.ac
> By default, do not build with -Wall, unless the user asks for it

There normally is no excuse for not using -Wall by default,
save for trying to compile it with msvc.


>AC_HEADER_STDC
>AC_HEADER_STDBOOL
>AC_CHECK_HEADERS([ fcntl.h limits.h locale.h ])
>AC_CHECK_HEADERS([ stdlib.h string.h sys/time.h unistd.h ])
>AC_TYPE_SIZE_T
>AC_FUNC_MALLOC
>AC_FUNC_REALLOC
>AC_FUNC_ALLOCA
>AC_CHECK_FUNCS([ bzero memmove memset ])
>AC_CHECK_FUNCS([ strcasecmp strchr strcspn strdup strncasecmp strpbrk strrchr
>strspn strtol ])
>AC_CHECK_FUNCS([ gettimeofday mkdir regcomp setlocale uname ])

All of this seems pointless because you never use the results
(HAVE_FCNTL_H, HAVE_LIMITS_H, etc.)


ncurses has the ncurses{w,}{6,5}-config scripts that ought to be called
to determine the locations.
