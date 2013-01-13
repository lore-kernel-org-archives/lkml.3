Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3AMVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 16:09:57 -0500
Received: from ares07.inai.de ([5.9.24.206]:57861 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab3AMVJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 16:09:56 -0500
Date: Sun, 13 Jan 2013 22:09:52 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kconfig-frontends-3.6.0-0 released
In-Reply-To: <201301131959.15246.yann.morin.1998@free.fr>
Message-ID: <alpine.LNX.2.01.1301132204090.9693@nerf07.vanv.qr>
References: <201210061755.07330.yann.morin.1998@free.fr> <alpine.LNX.2.01.1301121818330.15558@nerf07.vanv.qr> <201301131959.15246.yann.morin.1998@free.fr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2013-01-13 19:59, Yann E. MORIN wrote:
>> >printf "Running libtoolize...\n"
>> >libtoolize --copy --force
>> >printf "Running aclocal...\n"
>> >aclocal -Wall --force
>> 
>> Not again. autoreconf has existed for so long, why are people still 
>> hand-coding the boilerplate?
>
>(Note: this is my very first completely autotools-based package.)
>First, I have to admit that I looked at how other packages do it, and
>I mimicked what they do, rather than invent my own.

Ok, sensible. Yes, a lot of other packages make bad examples :(
Let's hope for them to be still alive and updated when automake 1.14
is out - it will remove and flag out some terribly old remnants.

>Second, I know of autoreconf, but it does not work for 'foreign' packages
>(ie. packages that do not have the NEWS and Changelog files, for example):
>
>[--SNIP--]
>Makefile.am: required file `./NEWS' not found                                                                                                                                                                                
>Makefile.am: required file `./ChangeLog' not found                                                                                                                                                                           
>[--SNIP--]
>
>I do not have a need for such files in this package. So, it is a 'foreign'
>package, and must be handled as such by automake.
>
>How does one autoreconf a 'foreign' package?

Surely, just that:
AM_INIT_AUTOMAKE([foreign])

>> > By default, do not build with -Wall, unless the user asks for it
>> 
>> There normally is no excuse for not using -Wall by default,
>> save for trying to compile it with msvc.
>
>Sorry, did you mean: "-Wall should be the default" ?

Indeed.

>Yes, I was thinking of building with -Wall by default once the packaging
>would be a bit more stable. Now seems like a good time to add this.

>
>> >AC_HEADER_STDC
>> >AC_HEADER_STDBOOL
>> >AC_CHECK_HEADERS([ fcntl.h limits.h locale.h ])
>> >AC_CHECK_HEADERS([ stdlib.h string.h sys/time.h unistd.h ])
>> >AC_TYPE_SIZE_T
>> >AC_FUNC_MALLOC
>> >AC_FUNC_REALLOC
>> >AC_FUNC_ALLOCA
>> >AC_CHECK_FUNCS([ bzero memmove memset ])
>> >AC_CHECK_FUNCS([ strcasecmp strchr strcspn strdup strncasecmp strpbrk strrchr
>> >strspn strtol ])
>> >AC_CHECK_FUNCS([ gettimeofday mkdir regcomp setlocale uname ])
>> 
>> All of this seems pointless because you never use the results
>> (HAVE_FCNTL_H, HAVE_LIMITS_H, etc.)
>
>Right. This is the output of autoscan.

I find that program quite useless..

>As I see it, the only action we could take is to bail out if any is missing.
>Is this what you meant?

You could do that, though I would simply direct users to read the compiler
error message. That enhances (hopefully) both their knowledge on compiling,
and reduces the walltime configure runs.

If I understood right, kconfig-frontends is supposed to run on non-Linux too,
and I have yet to see a modern platform that's missing any of the stdc
functions like malloc and strchr.
