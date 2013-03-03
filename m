Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3CCUXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:23:40 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57080 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3CCUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:23:39 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
Date: Sun, 3 Mar 2013 21:23:33 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: Sven Joachim <svenjoac@gmx.de>, jlec@gentoo.org,
        linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1362045557-9123-1-git-send-email-jlec@gentoo.org> <874ngwhzuy.fsf@turtle.gmx.de>
In-Reply-To: <874ngwhzuy.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303032123.34125.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven, Justin, All,

Sorry for the delay...

On Thursday 28 February 2013 Sven Joachim wrote:
> On 2013-02-28 10:59 +0100, jlec@gentoo.org wrote:
> 
> > Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
> > This patch makes use of it to detect the necessary libs for linking of the
> > ncurses nconfig dialog.
> 
> That script is not necessarily called ncurses5-config, it might also be
> called ncurses6-config is ncurses is configured for a different ABI
> (--enable-ext-colors, --enable-ext-mouse).  Although I would suspect
> that any distribution who does that provides a compatibility symlink.

Cygwin does provide nurses{,w}{5,6}-config.

> >  scripts/kconfig/Makefile | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> > index 3091794..c372976 100644
> > --- a/scripts/kconfig/Makefile
> > +++ b/scripts/kconfig/Makefile
> > @@ -216,7 +216,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
> >  
> >  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
> >  
> > -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> > +HOSTLOADLIBES_nconf	= -lmenu -lpanel
> > +HOSTLOADLIBES_nconf	+= $(shell    ncursesw5-config --libs 2>/dev/null \
> > +				   || ncurses5-config --libs 2>/dev/null  )
> 
> This will link with ncursesw, not ncurses.  Probably not what you want,
> since nconf.h does not #include the right headers for that.
> 
> On Debian/Ubuntu, there's also the problem that ncursesw5-config exists
> even if the libncursesw5-dev package is not installed, so this patch
> makes the build fail in such cases.

The same goes for ncurses5-config, which is provided by ncurses-bin, and
so is present even if the devel package is not installed, and the build
will break, too.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
