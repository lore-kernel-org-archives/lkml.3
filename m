Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab3CIC55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:57:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092Ab3CIC54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:57:56 -0500
Date: Fri, 8 Mar 2013 21:57:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: ebiederm@xmission.com
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309025752.GA13913@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, ebiederm@xmission.com
References: <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
 <20130308235514.GA5605@redhat.com>
 <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
 <20130309001917.GA6015@redhat.com>
 <20130309003617.GB6743@redhat.com>
 <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
 <20130309020318.GA11449@redhat.com>
 <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
 <20130309022623.GB11449@redhat.com>
 <20130309025631.GA13188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130309025631.GA13188@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 09:56:31PM -0500, Dave Jones wrote:
 > On Fri, Mar 08, 2013 at 09:26:23PM -0500, Dave Jones wrote:
 >  > On Fri, Mar 08, 2013 at 06:08:52PM -0800, Linus Torvalds wrote:
 >  >  > On Fri, Mar 8, 2013 at 6:03 PM, Dave Jones <davej@redhat.com> wrote:
 >  >  > >
 >  >  > > existing pathname + 'a' = fine.
 >  >  > >
 >  >  > > existing pathname + '/' + 'a' = boom.
 >  >  > 
 >  >  > Good.
 >  >  > 
 >  >  > > Looks like if I do this..
 >  >  > >
 >  >  > >        if (isdigit(newpath[len]) != 0) {
 >  >  > >                 newpath[len] = '/';
 >  >  > >                newpath[len+1] = 'A';
 >  >  > >                newpath[len+2] = 0;
 >  >  > >
 >  >  > > no bug.
 >  >  > 
 >  >  > Well, but that will never trigger. newpath[len] will always be NUL, so
 >  >  > you just disabled things entirely. Use "len-1".
 >  >  > 
 >  >  > So I don't think that did what you meant it to do.
 >  > 
 >  > Fixed that up, and even double checked my sanity by printing stuff out.
 >  > 
 >  > Confirmed that it's something that doesn't end in a number.
 >  
 > I've got a hunch that it's /proc/$$/ns/uts.
 > 
 > After 3-4 runs, that's the only common file in the last few that got mangled.
 > 
 > I'll do some more tests, but this might be the one.
 
confirmed.  A simple 

mkdir /proc/self/ns/uts/A

will trigger it.

Eric ?

	Dave

