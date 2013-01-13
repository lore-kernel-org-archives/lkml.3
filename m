Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3AMS7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 13:59:22 -0500
Received: from mail-wg0-f67.google.com ([74.125.82.67]:51383 "EHLO
	mail-wg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3AMS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 13:59:20 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Jan Engelhardt <jengelh@inai.de>
Subject: Re: kconfig-frontends-3.6.0-0 released
Date: Sun, 13 Jan 2013 19:59:15 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210061755.07330.yann.morin.1998@free.fr> <alpine.LNX.2.01.1301121818330.15558@nerf07.vanv.qr>
In-Reply-To: <alpine.LNX.2.01.1301121818330.15558@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301131959.15246.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, All,

On Saturday 12 January 2013 Jan Engelhardt wrote:
> On Saturday 2012-10-06 17:55, Yann E. MORIN wrote:
> >I'm pleased to announce the release of kconfig-frontends 3.6.0-0!
> >Go download it there:
> >    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.6.0-0.tar.xz
> 
> Please stick to a single separator, i.e. "3.6.0.0". The dash is already
> used by distributions to mark same-source releases.

Yes, that's already been fixed (for the reason you mention):
    http://ymorin.is-a-geek.org/hg/kconfig-frontends/rev/2d6b6198ef61

Note also that 3.7.0.0 has since been released with this correct
versionning scheme:
    http://www.spinics.net/lists/linux-kbuild/msg07020.html

> >And the repository can be browsed or hg-cloned from:
> >  http://ymorin.is-a-geek.org/hg/kconfig-frontends
> 
> Ugh, hg. There goes any chance for contributions.

I am not as confident with git as I am with Mercurial, hence my choice
of Mercurial rather than git. The most important to me was that the code
be available in some form of DVCS, *and* that I did not f*ck up the repo.

In the first announcement, I expressely noted that I wanted to switch to
using git:
    http://marc.info/?l=linux-kbuild&m=133219473622797&w=2

---8<---
The plans for the future are:
  [...]
  - migrate the repository to git (short-term)
---8<---

Well, short-term is not always as short as one would like... :-(
It's in progress, now that I have gained some confidence in my ability
not to f*ck up with git in less time than is needed to write it... ;-)

> bootstrap.sh
> >printf "Running libtoolize...\n"
> >libtoolize --copy --force
> >printf "Running aclocal...\n"
> >aclocal -Wall --force
> 
> Not again. autoreconf has existed for so long, why are people still 
> hand-coding the boilerplate?

(Note: this is my very first completely autotools-based package.)

First, I have to admit that I looked at how other packages do it, and
I mimicked what they do, rather than invent my own.

Second, I know of autoreconf, but it does not work for 'foreign' packages
(ie. packages that do not have the NEWS and Changelog files, for example):

[--SNIP--]
Makefile.am: required file `./NEWS' not found                                                                                                                                                                                
Makefile.am: required file `./ChangeLog' not found                                                                                                                                                                           
[--SNIP--]

I do not have a need for such files in this package. So, it is a 'foreign'
package, and must be handled as such by automake.

How does one autoreconf a 'foreign' package?

> configure.ac
> > By default, do not build with -Wall, unless the user asks for it
> 
> There normally is no excuse for not using -Wall by default,
> save for trying to compile it with msvc.

Sorry, did you mean: "-Wall should be the default" ?
Yes, I was thinking of building with -Wall by default once the packaging
would be a bit more stable. Now seems like a good time to add this.

> >AC_HEADER_STDC
> >AC_HEADER_STDBOOL
> >AC_CHECK_HEADERS([ fcntl.h limits.h locale.h ])
> >AC_CHECK_HEADERS([ stdlib.h string.h sys/time.h unistd.h ])
> >AC_TYPE_SIZE_T
> >AC_FUNC_MALLOC
> >AC_FUNC_REALLOC
> >AC_FUNC_ALLOCA
> >AC_CHECK_FUNCS([ bzero memmove memset ])
> >AC_CHECK_FUNCS([ strcasecmp strchr strcspn strdup strncasecmp strpbrk strrchr
> >strspn strtol ])
> >AC_CHECK_FUNCS([ gettimeofday mkdir regcomp setlocale uname ])
> 
> All of this seems pointless because you never use the results
> (HAVE_FCNTL_H, HAVE_LIMITS_H, etc.)

Right. This is the output of autoscan.

The source code is directly extracted from the Linux kernel source tree,
so we can't decently modify it to add checks around each #include directive.

As I see it, the only action we could take is to bail out if any is missing.
Is this what you meant?

Thank you for the review! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

