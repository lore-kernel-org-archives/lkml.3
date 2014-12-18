Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaLRRqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:46:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaLRRqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:46:37 -0500
Date: Thu, 18 Dec 2014 12:46:29 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Paul Moore <paul@paul-moore.com>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-audit@redhat.com
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
Message-ID: <20141218174629.GB29827@madcap2.tricolour.ca>
References: <2966.1418778594@turing-police.cc.vt.edu>
 <5444.1418921116@turing-police.cc.vt.edu>
 <1418921420.5162.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418921420.5162.19.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/18, Eric Paris wrote:
> On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> > > Spotted these two while booting single-user on 20141216.  20141208
> > > doesn't throw these, so it's something in the last week or so..
> > 
> > Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> > just fine for several days, but it went around the bend, apparently due
> > to a userspace or initrd change.
> 
> $5 says you updated systemd?
> 
> Richard?

Ok, so if you are correct, then either we justify dropping the lock (I
assume the one commone to both BUG reports [sig->cred_guard_mutex] ),
or we make yet another queue were were hoping to avoid...

It would also be good to narrow it down to a rule that triggers this.

> > egrep 'BUG|Linux vers' from my syslog:
> > 
> > Dec  9 12:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
...
> > Dec 12 19:42:30 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> > Dec 12 20:00:39 turing-police kernel: [ 1109.635328] BUG: sleeping function called from invalid context at mm/slab.c:2849
...
> > Dec 12 20:42:47 turing-police kernel: [ 3633.863552] BUG: sleeping function called from invalid context at mm/slab.c:2849
> > Dec 12 20:51:33 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> > Dec 12 21:51:04 turing-police kernel: [ 3587.132867] BUG: sleeping function called from invalid context at mm/slab.c:2849
...
> > I need to figure out what changed around 7:30PM on the 12th.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
