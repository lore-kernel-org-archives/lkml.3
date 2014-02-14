Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaBNR33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:29:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41214 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaBNR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:29:28 -0500
Date: Fri, 14 Feb 2014 09:29:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20140214172920.GQ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <1392183564.18779.2187.camel@triegel.csb>
 <20140212180739.GB4250@linux.vnet.ibm.com>
 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
 <20140213002355.GI4250@linux.vnet.ibm.com>
 <1392321837.18779.3249.camel@triegel.csb>
 <20140214020144.GO4250@linux.vnet.ibm.com>
 <1392352981.18779.3800.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392352981.18779.3800.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021417-8236-0000-0000-00000725B871
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 08:43:01PM -0800, Torvald Riegel wrote:
> On Thu, 2014-02-13 at 18:01 -0800, Paul E. McKenney wrote:

[ . . . ]

> > Another option would be to flag the conditional expression, prohibiting
> > the compiler from optimizing out any conditional branches.  Perhaps
> > something like this:
> > 
> > 	r1 = atomic_load(x, memory_order_control);
> > 	if (control_dependency(r1))
> > 		atomic_store(y, memory_order_relaxed);
> 
> That's the one I had in mind and talked to you about earlier today.  My
> gut feeling is that this is preferably over the other because it "marks"
> the if-statement, so the compiler knows exactly which branches matter.
> I'm not sure one would need the other memory order for that, if indeed
> all you want is relaxed -> branch -> relaxed.  But maybe there are
> corner cases (see the weaker-than-relaxed discussion in SG1 today).

Linus, Peter, any objections to marking places where we are relying on
ordering from control dependencies against later stores?  This approach
seems to me to have significant documentation benefits.

							Thanx, Paul

