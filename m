Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab3CICDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:03:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab3CICDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:03:22 -0500
Date: Fri, 8 Mar 2013 21:03:18 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309020318.GA11449@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com>
 <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
 <20130308233041.GA32587@redhat.com>
 <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
 <20130308235514.GA5605@redhat.com>
 <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
 <20130309001917.GA6015@redhat.com>
 <20130309003617.GB6743@redhat.com>
 <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 05:18:29PM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 4:36 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Ok, it's definitly the 'append something on the end of a valid pathname'
 > > changeset. 'something' can be anything it seems.
 > 
 > Ok. so maybe the way to "bisect" this is to play with that.
 > 
 > For example, does it happen even if the "something" does not have a
 > slash in it? IOW, you just append, say, a single 'a' character to a
 > name that doesn't already end in a slash?

existing pathname + 'a' = fine.

existing pathname + '/' + 'a' = boom.

 > And if it still does happen with that, perhaps you could have some
 > logic that only appends the 'a' to names that end with numbers. Does
 > it stop happening?
 
Looks like if I do this..

       if (isdigit(newpath[len]) != 0) {
                newpath[len] = '/';
               newpath[len+1] = 'A';
               newpath[len+2] = 0;

no bug.

If I change that to == 0, I get the bug.

 > The machine keeps running, right? So you can try this out without
 > rebooting, just changing when you append the character?

Sometimes it gets wedged somewhere, so not always.
Quick to reboot though, so no biggie.

Now trying to lower the frequency at which it does the mangling
to pinpoint the affected file(s)

I need to run at least 8 child processes (-C8) to get this to 
happen (machine has 4 cores). Unfortunatly that means the logging
gets a bit spewy if they're all mangling at the same time.

	Dave

