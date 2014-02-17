Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaBQVVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:21:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaBQVVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:21:39 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
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
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Feb 2014 22:21:03 +0100
Message-ID: <1392672063.18779.6940.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 12:18 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 11:55 AM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > Which example do you have in mind here?  Haven't we resolved all the
> > debated examples, or did I miss any?
> 
> Well, Paul seems to still think that the standard possibly allows
> speculative writes or possibly value speculation in ways that break
> the hardware-guaranteed orderings.

That's true, I just didn't see any specific examples so far.

> And personally, I can't read standards paperwork. It is invariably
> written in some basically impossible-to-understand lawyeristic mode,

Yeah, it's not the most intuitive form for things like the memory model.

> and then it is read by people (compiler writers) that intentionally
> try to mis-use the words and do language-lawyering ("that depends on
> what the meaning of 'is' is").

That assumption about people working on compilers is a little too broad,
don't you think?

I think that it is important to stick to a specification, in the same
way that one wouldn't expect a program with undefined behavior make any
sense of it, magically, in cases where stuff is undefined.

However, that of course doesn't include trying to exploit weasel-wording
(BTW, both users and compiler writers try to do it).  IMHO,
weasel-wording in a standard is a problem in itself even if not
exploited, and often it indicates that there is a real issue.  There
might be reasons to have weasel-wording (e.g., because there's no known
better way to express it like in case of the not really precise
no-out-of-thin-air rule today), but nonetheless those aren't ideal.

> The whole "lvalue vs rvalue expression
> vs 'what is a volatile access'" thing for C++ was/is a great example
> of that.

I'm not aware of the details of this.

> So quite frankly, as a result I refuse to have anything to do with the
> process directly.

That's unfortunate.  Then please work with somebody that isn't
uncomfortable with participating directly in the process.  But be
warned, it may very well be a person working on compilers :)

Have you looked at the formalization of the model by Batty et al.?  The
overview of this is prose, but the formalized model itself is all formal
relations and logic.  So there should be no language-lawyering issues
with that form.  (For me, the formalized model is much easier to reason
about.)

