Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3CCVm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:42:26 -0500
Received: from mout.gmx.net ([212.227.15.19]:57944 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3CCVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:42:22 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/S8lsCRf7SEqb1h5Zi8qcM/hEpbOoq9iF8sEq4Kq
	iiqLmFz1bdqrG8
From: Sven Joachim <svenjoac@gmx.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, jlec@gentoo.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org>
	<1362045557-9123-1-git-send-email-jlec@gentoo.org>
	<874ngwhzuy.fsf@turtle.gmx.de>
	<201303032123.34125.yann.morin.1998@free.fr>
Date: Sun, 03 Mar 2013 22:37:16 +0100
In-Reply-To: <201303032123.34125.yann.morin.1998@free.fr> (Yann E. MORIN's
	message of "Sun, 3 Mar 2013 21:23:33 +0100")
Message-ID: <874ngsf9mb.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-03 21:23 +0100, Yann E. MORIN wrote:

> On Thursday 28 February 2013 Sven Joachim wrote:
>> On 2013-02-28 10:59 +0100, jlec@gentoo.org wrote:
>
>> >  scripts/kconfig/Makefile | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
>> > index 3091794..c372976 100644
>> > --- a/scripts/kconfig/Makefile
>> > +++ b/scripts/kconfig/Makefile
>> > @@ -216,7 +216,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>> >  
>> >  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>> >  
>> > -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
>> > +HOSTLOADLIBES_nconf	= -lmenu -lpanel
>> > +HOSTLOADLIBES_nconf	+= $(shell    ncursesw5-config --libs 2>/dev/null \
>> > +				   || ncurses5-config --libs 2>/dev/null  )
>> 
>> This will link with ncursesw, not ncurses.  Probably not what you want,
>> since nconf.h does not #include the right headers for that.
>> 
>> On Debian/Ubuntu, there's also the problem that ncursesw5-config exists
>> even if the libncursesw5-dev package is not installed, so this patch
>> makes the build fail in such cases.
>
> The same goes for ncurses5-config, which is provided by ncurses-bin, and
> so is present even if the devel package is not installed, and the build
> will break, too.

This is not the same: if libncurses5-dev is not installed, the build is
going to fail anyway, since there is no -lmenu or -lpanel then.

I second the proposal to try pkg-config and fall back to -lncurses, BTW.

Cheers,
       Sven
