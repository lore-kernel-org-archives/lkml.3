Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaBQTUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:20:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38293 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbaBQTUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:20:01 -0500
Date: Mon, 17 Feb 2014 19:19:14 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Torvald Riegel <triegel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140217191914.GG26590@mudshark.cambridge.arm.com>
References: <1392321837.18779.3249.camel@triegel.csb>
 <20140214020144.GO4250@linux.vnet.ibm.com>
 <1392352981.18779.3800.camel@triegel.csb>
 <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <20140215020815.GS4250@linux.vnet.ibm.com>
 <CA+55aFyQTE-CzOoNn=KfDgt9bTLrUxBCXzhQ2T9kNoTy+bRQrQ@mail.gmail.com>
 <1392487627.18779.6535.camel@triegel.csb>
 <Pine.LNX.4.64.1402171856400.29680@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1402171856400.29680@digraph.polyomino.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 06:59:31PM +0000, Joseph S. Myers wrote:
> On Sat, 15 Feb 2014, Torvald Riegel wrote:
> 
> > glibc is a counterexample that comes to mind, although it's a smaller
> > code base.  (It's currently not using C11 atomics, but transitioning
> > there makes sense, and some thing I want to get to eventually.)
> 
> glibc is using C11 atomics (GCC builtins rather than _Atomic / 
> <stdatomic.h>, but using __atomic_* with explicitly specified memory model 
> rather than the older __sync_*) on AArch64, plus in certain cases on ARM 
> and MIPS.

Hmm, actually that results in a change in behaviour for the __sync_*
primitives on AArch64. The documentation for those states that:

  `In most cases, these built-in functions are considered a full barrier. That
  is, no memory operand is moved across the operation, either forward or
  backward. Further, instructions are issued as necessary to prevent the
  processor from speculating loads across the operation and from queuing stores
  after the operation.'

which is stronger than simply mapping them to memory_model_seq_cst, which
seems to be what the AArch64 compiler is doing (so you get acquire + release
instead of a full fence).

Will
