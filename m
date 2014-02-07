Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaBGRq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:46:56 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:35733 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBGRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:46:54 -0500
Date: Fri, 7 Feb 2014 17:46:41 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Peter Zijlstra <peterz@infradead.org>
CC: Will Deacon <will.deacon@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
In-Reply-To: <20140207170654.GQ5002@laptop.programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.64.1402071740330.7304@digraph.polyomino.org.uk>
References: <52F3DA85.1060209@arm.com> <20140206185910.GE27276@mudshark.cambridge.arm.com>
 <20140206192743.GH4250@linux.vnet.ibm.com> <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com> <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com> <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com> <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207170654.GQ5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 07 Feb 2014 17:46:44.0892 (UTC) FILETIME=[911EF5C0:01CF242C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Peter Zijlstra wrote:

> There's further problems where things like memset() can write outside
> the specified address range. Examples are memset() using single
> instructions to wipe entire cachelines and then 'restoring' the tail
> bit.

If memset (or any C library function) modifies bytes it's not permitted to 
modify in the abstract machine, that's a simple bug and should be reported 
as usual.  We've made GCC follow that part of the memory model by default 
(so a store to a non-bit-field structure field doesn't do a 
read-modify-write to a word containing another field, for example) and I 
think it's pretty obvious that glibc should do so as well.

(Of course, memset is not an atomic operation, and you need to allow for 
that if you use it on an _Atomic object - which is I think valid, unless 
the object is also volatile, but perhaps ill-advised.)

-- 
Joseph S. Myers
joseph@codesourcery.com
