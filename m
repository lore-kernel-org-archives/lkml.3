Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaBRRkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:40:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaBRRkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:40:21 -0500
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
In-Reply-To: <CA+55aFxw+k66jgOVKr0nDuUA91svcZKkBb5purMbfPrO+C+5sQ@mail.gmail.com>
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
	 <1392485428.18779.6387.camel@triegel.csb>
	 <CA+55aFw5v8Zc818YoxazFhP0btN1faofNbED=qrpi3VrtRA39w@mail.gmail.com>
	 <1392674986.18779.7038.camel@triegel.csb>
	 <CA+55aFz-gaNKxRGU-YPw3xu=T8ZxFv0v22i+R7vWoeQT0i+8Mw@mail.gmail.com>
	 <1392679048.18779.7168.camel@triegel.csb>
	 <CA+55aFxw+k66jgOVKr0nDuUA91svcZKkBb5purMbfPrO+C+5sQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 16:46:57 +0100
Message-ID: <1392738417.18779.7675.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 16:09 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 3:17 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Mon, 2014-02-17 at 14:32 -0800,
> >
> >> Stop claiming it "can return 1".. It *never* returns 1 unless you do
> >> the load and *verify* it, or unless the load itself can be made to go
> >> away. And with the code sequence given, that just doesn't happen. END
> >> OF STORY.
> >
> > void foo();
> > {
> >   atomic<int> x = 1;
> >   if (atomic_load(&x, mo_relaxed) == 1)
> >     atomic_store(&y, 3, mo_relaxed));
> > }
> 
> This is the very example I gave, where the real issue is not that "you
> prove that load returns 1", you instead say "store followed by a load
> can be combined".
> 
> I (in another email I just wrote) tried to show why the "prove
> something is true" is a very dangerous model.  Seriously, it's pure
> crap. It's broken.

I don't see anything dangerous in the example above with the language
semantics as specified: It's a well-defined situation, given the rules
of the language.  I replied to the other email you wrote with my
viewpoint on why the above is useful, how it compares to what you seem
to what, and where I think we need to start to bridge the gap.

> If the C standard defines atomics in terms of "provable equivalence",
> it's broken. Exactly because on a *virtual* machine you can prove
> things that are not actually true in a *real* machine.

For the control dependencies you have in mind, it's actually the other
way around.  You expect the real machine's properties in a program whose
semantics only give you the virtual machine's properties.  Anything you
prove on the virtual machine will be true on the real machine (in a
correct implementation) -- but you can't expect to have real-machine
properties on language that's based on the virtual machine.

> I have the
> example of value speculation changing the memory ordering model of the
> actual machine.

This example is not true for the language as specified.  It is true for
a modified language that you have in mind, but for this one I've just
seen pretty rough rules so far.  Please see my other reply.

