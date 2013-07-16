Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab3GPSUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:20:52 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933334Ab3GPSUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:20:51 -0400
Message-ID: <51E58EFF.1040703@nod.at>
Date: Tue, 16 Jul 2013 20:20:47 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com> <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com> <20130716174708.GN4165@ZenIV.linux.org.uk> <CALkWK0mY8OgqUiOAmyLzZpaS1U7Vw_xPSHytqggikGWBoghd_g@mail.gmail.com>
In-Reply-To: <CALkWK0mY8OgqUiOAmyLzZpaS1U7Vw_xPSHytqggikGWBoghd_g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 20:12, schrieb Ramkumar Ramachandra:
> Al Viro wrote:
>> As for the devices, they are *not* bogus.  RTFM, already.
>> Documentation/virtual/uml/UserModeLinux-HOWTO.txt, if you can't be bothered
>> to say git grep UML Documentation/ and find where it on your own.  The
>> relevant section is called "Setting up serial lines and consoles".
>> Seriously, it's not as if the documentation didn't exist or had been
>> hard to find...
> 
> Yes; I've been trying to decipher the con thing for some time now.
> 
>> FWIW, default config is rather annoying - 6 xterms spawned and associated
>> with /dev/tty[1-6].  con0=fd:0,fd:1 con=pts mentioned in the HOWTO would,
>> IMO, make for much saner default.
> 
> Leave aside the fact that I could not find the uml-utils upstream [1],

http://user-mode-linux.sourceforge.net/downloads.html

> and didn't have a /uml/port-helper to connect the xterms for a second;
> I didn't even understand what was supposed to happen.  Why do we spawn
> xterms, and attach to the host's /dev/tty*?  So far, I just used
> /dev/console inside my existing tmux session in urxvt, and it seems to
> work fine.
> 
>> No comments on systemd behaviour - take that with LP and his crowd.  They
>> may or may not be confused by /dev/tty1 not being a virtual console.
> 
> From my brief discussion with Lennart, he's just following what
> Documentation/devices.txt says: /dev/tty* are virtual consoles.  If um
> is making some sort of exception for good reason, I'm sure systemd can
> accommodate it.

/me wonders since when /dev/ttyS0 is a virtual console...

Thanks,
//richard
