Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaLSEDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 23:03:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaLSEDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 23:03:46 -0500
Date: Thu, 18 Dec 2014 23:03:08 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219040308.GB20022@redhat.com>
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
References: <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
 <20141215055707.GA26225@redhat.com>
 <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141219035859.GA20022@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 10:58:59PM -0500, Dave Jones wrote:
 >  > lock debugging and other overheads (does this still have
 >  > DEBUG_PAGEALLOC?) you really are getting into a "real" softlockup
 >  > because things are scaling so horribly badly.
 >  > 
 >  > If you now disable spinlock debugging and lockdep, hopefully that page
 >  > table lock now doesn't always get hung up on the lockdep locking, so
 >  > it starts scaling much better, and maybe you'd not see this...
 > 
 > I can give it a shot.  Hopefully there's some further mitigation that
 > could be done to allow a workload like this to survive under a debug
 > build though, as we've caught *so many* bugs with this stuff in the past.
 
Turns out also that this build didn't have PROVE_LOCKING enabled.
CONFIG_LOCKDEP was, but that just bloats the structures a little, and
afaik doesn't incur the same runtime overhead.

I also forgot to answer the question above, PAGEALLOC is also off.

So the only thing that was on that could cause spinlock overhead
was DEBUG_SPINLOCK (and LOCK_STAT, though iirc that's not huge either)

	Dave
