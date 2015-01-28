Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbbA1U6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:58:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbA1U57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:59 -0500
Date: Wed, 28 Jan 2015 09:15:06 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: restore tty settings after closing console
Message-ID: <20150128151506.GB26843@treble.redhat.com>
References: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
 <20150127170129.7db53047@gandalf.local.home>
 <20150128145923.GA26843@treble.redhat.com>
 <20150128100831.18cdad60@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150128100831.18cdad60@gandalf.local.home>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:08:31AM -0500, Steven Rostedt wrote:
> On Wed, 28 Jan 2015 08:59:23 -0600
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > On Tue, Jan 27, 2015 at 05:01:29PM -0500, Steven Rostedt wrote:
> > > On Tue, 27 Jan 2015 12:10:04 -0600
> > > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > 
> > > > When ktest runs the console program as a child process, the parent and
> > > > child share the same tty for stdin and stderr.  This is problematic when
> > > > using a libvirt target.  The "virsh console" program makes a lot of
> > > > changes to the tty settings, making ktest's output hard to read
> > > > (carriage returns don't work).  After ktest exits, the terminal is
> > > > unusable (CRs broken, stdin isn't echoed).
> > > > 
> > > > I think the best way to fix this issue would be to create a
> > > > pseudoterminal (pty pair) so the child process would have a dedicated
> > > > tty, and then use pipes to connect the two ttys.  I'm not sure if that's
> > > > overkill, but it's far beyond my current Perl abilities.
> > > 
> > > And beyond mine too. I tried to get that right a few times, and it
> > > never worked out. Maybe someone with more oyster skilz can fix this.
> > 
> > I decided to level up my oyster skilz.  I came up with this (to be
> > applied instead of the original patch).  It's working well for me.
> 
> I already applied your other patch. If there's any other work, please
> apply it on top. I in the process of testing other changes on top of
> this too. I'll be pushing it soon to my for-next linux-ktest.git tree,
> after I'm finished testing.
> 
> 
> > Right now, stdin isn't hooked up, so the user can't mess with the
> > console.  Is stdin needed?
> 
> Actually, I do. I found it's nice to move things along when the console
> shows grub or syslinux options, and I can hit enter and it continues.
> 
> It's not critical, but it's a freebee for me.

Ok, I'll add stdin for v2.

-- 
Josh
