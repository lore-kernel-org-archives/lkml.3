Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaBSJqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:46:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaBSJqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:46:46 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter.Sewell@cl.cam.ac.uk
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        "ramana.radhakrishnan" <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CAHWkzRTZk-7JtzHDHBQ++cSY83Hmd+P-0KUposaQN7htW1CxUA@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	 <1392756211.18779.8263.camel@triegel.csb>
	 <CAHWkzRTZk-7JtzHDHBQ++cSY83Hmd+P-0KUposaQN7htW1CxUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 10:46:04 +0100
Message-ID: <1392803164.18779.8498.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 23:48 +0000, Peter Sewell wrote:
> On 18 February 2014 20:43, Torvald Riegel <triegel@redhat.com> wrote:
> > On Tue, 2014-02-18 at 12:12 +0000, Peter Sewell wrote:
> >> Several of you have said that the standard and compiler should not
> >> permit speculative writes of atomics, or (effectively) that the
> >> compiler should preserve dependencies.  In simple examples it's easy
> >> to see what that means, but in general it's not so clear what the
> >> language should guarantee, because dependencies may go via non-atomic
> >> code in other compilation units, and we have to consider the extent to
> >> which it's desirable to limit optimisation there.
> >
> > [...]
> >
> >> 2) otherwise, the language definition should prohibit it but the
> >>    compiler would have to preserve dependencies even in compilation
> >>    units that have no mention of atomics.  It's unclear what the
> >>    (runtime and compiler development) cost of that would be in
> >>    practice - perhaps Torvald could comment?
> >
> > If I'm reading the standard correctly, it requires that data
> > dependencies are preserved through loads and stores, including nonatomic
> > ones.  That sounds convenient because it allows programmers to use
> > temporary storage.
> 
> The standard only needs this for consume chains,

That's right, and the runtime cost / implementation problems of
mo_consume was what I was making statements about.  Sorry if that wasn't
clear.

