Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaBZSn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:43:57 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:55097 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZSn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:43:56 -0500
Date: Wed, 26 Feb 2014 18:43:44 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Torvald Riegel <triegel@redhat.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Matz <matz@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
In-Reply-To: <1393420157.28840.8691.camel@triegel.csb>
Message-ID: <Pine.LNX.4.64.1402261840540.11728@digraph.polyomino.org.uk>
References: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
  <20140220083032.GN4250@linux.vnet.ibm.com> 
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com> 
 <20140220181116.GT4250@linux.vnet.ibm.com> 
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com> 
 <20140220185608.GX4250@linux.vnet.ibm.com> 
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com> 
 <20140220221027.GC4250@linux.vnet.ibm.com> 
 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com> 
 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>  <20140221191318.GK4250@linux.vnet.ibm.com>
  <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
 <1393420157.28840.8691.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 26 Feb 2014 18:43:47.0698 (UTC) FILETIME=[AF1EF520:01CF3322]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014, Torvald Riegel wrote:

> On Fri, 2014-02-21 at 22:10 +0000, Joseph S. Myers wrote:
> > On Fri, 21 Feb 2014, Paul E. McKenney wrote:
> > 
> > > This needs to be as follows:
> > > 
> > > [[carries_dependency]] int getzero(int i [[carries_dependency]])
> > > {
> > > 	return i - i;
> > > }
> > > 
> > > Otherwise dependencies won't get carried through it.
> > 
> > C11 doesn't have attributes at all (and no specification regarding calls 
> > and dependencies that I can see).  And the way I read the C++11 
> > specification of carries_dependency is that specifying carries_dependency 
> > is purely about increasing optimization of the caller: that if it isn't 
> > specified, then the caller doesn't know what dependencies might be 
> > carried.  "Note: The carries_dependency attribute does not change the 
> > meaning of the program, but may result in generation of more efficient 
> > code. - end note".
> 
> I think that this last sentence can be kind of misleading, especially
> when looking at it from an implementation point of view.  How
> dependencies are handled (ie, preserving the syntactic dependencies vs.
> emitting barriers) must be part of the ABI, or things like
> [[carries_dependency]] won't work as expected (or lead to inefficient
> code).  Thus, in practice, all compiler vendors on a platform would have
> to agree to a particular handling, which might end up in selecting the
> easy-but-conservative implementation option (ie, always emitting
> mo_acquire when the source uses mo_consume).

Regardless of the ABI, my point is that if a program is valid, it is also 
valid when all uses of [[carries_dependency]] are removed.  If a function 
doesn't use [[carries_dependency]], that means "dependencies may or may 
not be carried through this function".  If a function uses 
[[carries_dependency]], that means that certain dependencies *are* carried 
through the function (and the ABI should then specify what this means the 
caller can rely on, in terms of the architecture's memory model).  (This 
may or may not be useful, but it's how I understand C++11.)

-- 
Joseph S. Myers
joseph@codesourcery.com
