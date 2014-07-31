Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaGaIHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:07:23 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5519 "EHLO
	esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbaGaIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:07:13 -0400
Subject: Re: [PATCH -v4] random: introduce getrandom(2) system call
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: Bob Beck <beck@openbsd.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Theo de Raadt <deraadt@cvs.openbsd.org>
Date: Thu, 31 Jul 2014 10:06:37 +0200
In-Reply-To: <20140730221819.GB18189@amd.pavel.ucw.cz>
References: <1405718127-30042-1-git-send-email-tytso@mit.edu>
	 <20140730122620.GC13965@amd.pavel.ucw.cz>
	 <CAComcpMnAdOk=Hs8Dtc7VZeJDHnpKQtzZ_=_67tqCeYU3pdJ_Q@mail.gmail.com>
	 <1406731254.26034.4.camel@thorin> <20140730221819.GB18189@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1406794012.26034.14.camel@thorin>
Mime-Version: 1.0
X-DCC--Metrics: esgaroth.tuxoid.at 1102; Body=7 Fuz1=7 Fuz2=7
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2014-07-31 at 00:18 +0200, Pavel Machek wrote:
> On Wed 2014-07-30 16:40:52, Bernd Petrovitsch wrote:
> > On Mit, 2014-07-30 at 07:56 -0600, Bob Beck wrote:
> > > Pavel. I have bit 'ol enterprise daemon running with established file
> > > descriptors serving thousands of connections
> > > which periodically require entropy.  Now I run out of descriptors. I
> > > can't establish new connections. but I should
> > > now halt all the other ones that require entropy?  I should raise
> > > SIGKILL on my process serving these thousands
> > > of connetions?  I don't think so.
> > 
> > If that long-running daemon periodically needs something from a device,
> > one would better keep the fd for that open the whole time. Saves some
> > CPU cycles and latency too BTW.
> 
> Agreed.
> 
> On the other hand, keeping a fd open is quite tricky for a
> library. But better solution might be to make that easier.

Yes, in a (full-fledged, standalone) library seems at least tricky (also
referring to some off-list mails here: think about fork() - which could
be inside system() or popen() or similar). 

But as part of the *application* (where one has control over fork()
etc.), this should be somewhat less risky. Yes, that doesn't really help
libssl;-)

Hehe, we (Unix!) have (had) gettimeofday(), time() and similar sys-calls
since ages and no one proposed to make devices for them and get rid of
the system-calls.

> open( , O_IM_A_LIBRARY_GIVE_ME_ONE_OF_THREE_RESERVED_FDS) might be one
> solution. Actually, one reserved fd should be enough.

Well, this can also be DoSed and the proposal aims to make that
impossible (and where does this reserved count against? process-limits,
kernel-wide limit?).

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

