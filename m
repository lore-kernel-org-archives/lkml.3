Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaBUWLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:11:13 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:55759 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaBUWLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:11:09 -0500
Date: Fri, 21 Feb 2014 22:10:54 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Michael Matz <matz@suse.de>,
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
In-Reply-To: <20140221191318.GK4250@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1402212206040.16563@digraph.polyomino.org.uk>
References: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <20140220185608.GX4250@linux.vnet.ibm.com>
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
 <20140220221027.GC4250@linux.vnet.ibm.com>
 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de> <20140221191318.GK4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 21 Feb 2014 22:10:57.0947 (UTC) FILETIME=[CC0FAEB0:01CF2F51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Paul E. McKenney wrote:

> This needs to be as follows:
> 
> [[carries_dependency]] int getzero(int i [[carries_dependency]])
> {
> 	return i - i;
> }
> 
> Otherwise dependencies won't get carried through it.

C11 doesn't have attributes at all (and no specification regarding calls 
and dependencies that I can see).  And the way I read the C++11 
specification of carries_dependency is that specifying carries_dependency 
is purely about increasing optimization of the caller: that if it isn't 
specified, then the caller doesn't know what dependencies might be 
carried.  "Note: The carries_dependency attribute does not change the 
meaning of the program, but may result in generation of more efficient 
code. - end note".

-- 
Joseph S. Myers
joseph@codesourcery.com
