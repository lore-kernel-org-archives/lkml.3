Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbbA2Dcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:32:54 -0500
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:49481 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755159AbbA2Bo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4385:5007:6119:6120:6261:7875:7901:7903:9108:10004:10400:10848:10967:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:14096:14097:14130:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake89_67b350208ea4a
X-Filterd-Recvd-Size: 2782
Date: Wed, 28 Jan 2015 10:08:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: restore tty settings after closing console
Message-ID: <20150128100831.18cdad60@gandalf.local.home>
In-Reply-To: <20150128145923.GA26843@treble.redhat.com>
References: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
	<20150127170129.7db53047@gandalf.local.home>
	<20150128145923.GA26843@treble.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 08:59:23 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Tue, Jan 27, 2015 at 05:01:29PM -0500, Steven Rostedt wrote:
> > On Tue, 27 Jan 2015 12:10:04 -0600
> > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > When ktest runs the console program as a child process, the parent and
> > > child share the same tty for stdin and stderr.  This is problematic when
> > > using a libvirt target.  The "virsh console" program makes a lot of
> > > changes to the tty settings, making ktest's output hard to read
> > > (carriage returns don't work).  After ktest exits, the terminal is
> > > unusable (CRs broken, stdin isn't echoed).
> > > 
> > > I think the best way to fix this issue would be to create a
> > > pseudoterminal (pty pair) so the child process would have a dedicated
> > > tty, and then use pipes to connect the two ttys.  I'm not sure if that's
> > > overkill, but it's far beyond my current Perl abilities.
> > 
> > And beyond mine too. I tried to get that right a few times, and it
> > never worked out. Maybe someone with more oyster skilz can fix this.
> 
> I decided to level up my oyster skilz.  I came up with this (to be
> applied instead of the original patch).  It's working well for me.

I already applied your other patch. If there's any other work, please
apply it on top. I in the process of testing other changes on top of
this too. I'll be pushing it soon to my for-next linux-ktest.git tree,
after I'm finished testing.


> Right now, stdin isn't hooked up, so the user can't mess with the
> console.  Is stdin needed?

Actually, I do. I found it's nice to move things along when the console
shows grub or syslinux options, and I can hit enter and it continues.

It's not critical, but it's a freebee for me.

-- Steve

