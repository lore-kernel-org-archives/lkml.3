Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3GPSNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:13:39 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41396 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab3GPSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130716174708.GN4165@ZenIV.linux.org.uk>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
 <20130716174708.GN4165@ZenIV.linux.org.uk>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 23:42:55 +0530
Message-ID: <CALkWK0mY8OgqUiOAmyLzZpaS1U7Vw_xPSHytqggikGWBoghd_g@mail.gmail.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> As for the devices, they are *not* bogus.  RTFM, already.
> Documentation/virtual/uml/UserModeLinux-HOWTO.txt, if you can't be bothered
> to say git grep UML Documentation/ and find where it on your own.  The
> relevant section is called "Setting up serial lines and consoles".
> Seriously, it's not as if the documentation didn't exist or had been
> hard to find...

Yes; I've been trying to decipher the con thing for some time now.

> FWIW, default config is rather annoying - 6 xterms spawned and associated
> with /dev/tty[1-6].  con0=fd:0,fd:1 con=pts mentioned in the HOWTO would,
> IMO, make for much saner default.

Leave aside the fact that I could not find the uml-utils upstream [1],
and didn't have a /uml/port-helper to connect the xterms for a second;
I didn't even understand what was supposed to happen.  Why do we spawn
xterms, and attach to the host's /dev/tty*?  So far, I just used
/dev/console inside my existing tmux session in urxvt, and it seems to
work fine.

> No comments on systemd behaviour - take that with LP and his crowd.  They
> may or may not be confused by /dev/tty1 not being a virtual console.

>From my brief discussion with Lennart, he's just following what
Documentation/devices.txt says: /dev/tty* are virtual consoles.  If um
is making some sort of exception for good reason, I'm sure systemd can
accommodate it.

> One
> practical issue is the lack of VT102 emulation;

This detail is not at all clear from the Documentation.  I spent a lot
of time trying to figure out why systemd wasn't able to getty on
/dev/tty1.

> TERM=linux when logged
> in on those is not right - you want either TERM=xterm (for xterms) or
> TERM=screen (when accessing pts-associated ones with screen /dev/pts/n),
> etc.  In any case, it's a dumb serial line as far as the guest kernel
> is concerned - all terminal emulation is going to happen elsewhere (xterms
> running on host and interpreting escape sequences from guest userland,
> etc.)

Hm, what does $TERM have to do with all this?

[1]: A fabulously empty git repository here:
sourceforge.net/p/user-mode-linux/git/ref/master/
