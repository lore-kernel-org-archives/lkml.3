Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3AMWGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 17:06:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62751 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3AMWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:06:13 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Jan Engelhardt <jengelh@inai.de>
Subject: Re: kconfig-frontends-3.6.0-0 released
Date: Sun, 13 Jan 2013 22:58:44 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210061755.07330.yann.morin.1998@free.fr> <201301131959.15246.yann.morin.1998@free.fr> <alpine.LNX.2.01.1301132204090.9693@nerf07.vanv.qr>
In-Reply-To: <alpine.LNX.2.01.1301132204090.9693@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301132258.45084.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, All,

On Sunday 13 January 2013 Jan Engelhardt wrote:
> On Sunday 2013-01-13 19:59, Yann E. MORIN wrote:
> >> Not again. autoreconf has existed for so long, why are people still 
> >> hand-coding the boilerplate?
[--SNIP--]
> >How does one autoreconf a 'foreign' package?
> 
> Surely, just that:
> AM_INIT_AUTOMAKE([foreign])

Aha! :-)

Just one small nit left: autoreconf does not grok AC_CONFIG_MACRO_DIR and
does not create it, so aclocal complains. Easily worked around, though.

> >> >AC_HEADER_STDC
> >> >AC_HEADER_STDBOOL
> >> >AC_CHECK_HEADERS([ fcntl.h limits.h locale.h ])
> >> >AC_CHECK_HEADERS([ stdlib.h string.h sys/time.h unistd.h ])
[--SNIP--]
> >> All of this seems pointless because you never use the results
> >> (HAVE_FCNTL_H, HAVE_LIMITS_H, etc.)
[--SNIP--]
> >As I see it, the only action we could take is to bail out if any is missing.
> >Is this what you meant?
> 
> You could do that, though I would simply direct users to read the compiler
> error message. That enhances (hopefully) both their knowledge on compiling,
> and reduces the walltime configure runs.

OK, sounds reasonable.

> If I understood right, kconfig-frontends is supposed to run on non-Linux too,
> and I have yet to see a modern platform that's missing any of the stdc
> functions like malloc and strchr.

Yes, this is reasonable too. I'll do that.

Thank you very much! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

