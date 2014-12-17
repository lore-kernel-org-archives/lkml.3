Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaLQURK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 15:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLQURJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:17:09 -0500
Date: Wed, 17 Dec 2014 15:16:30 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141217201630.GA27208@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <20141217182241.GA4821@redhat.com>
 <20141217185755.GA22839@redhat.com>
 <CA+55aFyiFDeBmMB9NNjEwB4n8rtxjH3bWt+6gQ7skiZtDX3m=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyiFDeBmMB9NNjEwB4n8rtxjH3bWt+6gQ7skiZtDX3m=Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:51:45AM -0800, Linus Torvalds wrote:
 > On Wed, Dec 17, 2014 at 10:57 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Wed, Dec 17, 2014 at 01:22:41PM -0500, Dave Jones wrote:
 > >
 > >  > I'm going to try your two patches on top of .18, with the same kernel
 > >  > config, and see where that takes us.
 > >  > Hopefully to happier places.
 > >
 > > Not so much.  Died very quickly.
 > 
 > Damn, damn, damn. That's because of a stupid typo on the patches. We
 > have these very similar variables ("flags" and "fault") that have very
 > similar fault information, but they are completely different.
 > 
 > The "fault & FAULT_FLAG_USER" test is wrong, it should test "flags &
 > FAULT_FLAG_USER". Patch attached.

Yup, that seems to be the only obvious bug in those commits.
It's survived for long with that change on top.

 > The half-way good news is that this certainly confirms that trinity is
 > triggering the "page fault with fatal signal pending" special case.

Now let's see how long it runs for..

	Dave
