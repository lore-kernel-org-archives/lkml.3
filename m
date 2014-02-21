Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaBUWht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:37:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36091 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaBUWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:37:47 -0500
Date: Fri, 21 Feb 2014 14:37:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Michael Matz <matz@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140221223741.GO4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <20140220185608.GX4250@linux.vnet.ibm.com>
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
 <20140220221027.GC4250@linux.vnet.ibm.com>
 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
 <20140221191318.GK4250@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022122-0928-0000-0000-000006B10351
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:10:54PM +0000, Joseph S. Myers wrote:
> On Fri, 21 Feb 2014, Paul E. McKenney wrote:
> 
> > This needs to be as follows:
> > 
> > [[carries_dependency]] int getzero(int i [[carries_dependency]])
> > {
> > 	return i - i;
> > }
> > 
> > Otherwise dependencies won't get carried through it.
> 
> C11 doesn't have attributes at all (and no specification regarding calls 
> and dependencies that I can see).  And the way I read the C++11 
> specification of carries_dependency is that specifying carries_dependency 
> is purely about increasing optimization of the caller: that if it isn't 
> specified, then the caller doesn't know what dependencies might be 
> carried.  "Note: The carries_dependency attribute does not change the 
> meaning of the program, but may result in generation of more efficient 
> code. - end note".

Good point -- I am so used to them being in gcc that I missed that.

In which case, it seems to me that straight C11 is within its rights
to emit a memory barrier just before control passes into a function
that either it can't see or that it chose to apply dependency-breaking
optimizations to.

							Thanx, Paul

