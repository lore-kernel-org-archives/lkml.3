Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab3GPRrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:47:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3GPRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:47:11 -0400
Date: Tue, 16 Jul 2013 18:47:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
Message-ID: <20130716174708.GN4165@ZenIV.linux.org.uk>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at>
 <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:36:25PM +0530, Ramkumar Ramachandra wrote:
> Richard Weinberger wrote:
> > If you don't want devtmpfs, just disable it in your config.
> 
> I don't understand: is this not a good default?  Why is creating bogus
> devices, confusing systemd, and making um Linux hard to boot
> desirable?

As for the devices, they are *not* bogus.  RTFM, already.
Documentation/virtual/uml/UserModeLinux-HOWTO.txt, if you can't be bothered
to say git grep UML Documentation/ and find where it on your own.  The
relevant section is called "Setting up serial lines and consoles".
Seriously, it's not as if the documentation didn't exist or had been
hard to find...

FWIW, default config is rather annoying - 6 xterms spawned and associated
with /dev/tty[1-6].  con0=fd:0,fd:1 con=pts mentioned in the HOWTO would,
IMO, make for much saner default.

No comments on systemd behaviour - take that with LP and his crowd.  They
may or may not be confused by /dev/tty1 not being a virtual console.  One
practical issue is the lack of VT102 emulation; TERM=linux when logged
in on those is not right - you want either TERM=xterm (for xterms) or
TERM=screen (when accessing pts-associated ones with screen /dev/pts/n),
etc.  In any case, it's a dumb serial line as far as the guest kernel
is concerned - all terminal emulation is going to happen elsewhere (xterms
running on host and interpreting escape sequences from guest userland,
etc.)
