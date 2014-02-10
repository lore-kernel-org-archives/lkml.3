Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBJA43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:56:29 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61871 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaBJA41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:56:27 -0500
MIME-Version: 1.0
In-Reply-To: <1391992071.18779.99.camel@triegel.csb>
References: <52F3DA85.1060209@arm.com>
	<20140206185910.GE27276@mudshark.cambridge.arm.com>
	<20140206192743.GH4250@linux.vnet.ibm.com>
	<1391721423.23421.3898.camel@triegel.csb>
	<20140206221117.GJ4250@linux.vnet.ibm.com>
	<1391730288.23421.4102.camel@triegel.csb>
	<20140207042051.GL4250@linux.vnet.ibm.com>
	<20140207074405.GM5002@laptop.programming.kicks-ass.net>
	<20140207165028.GO4250@linux.vnet.ibm.com>
	<20140207165548.GR5976@mudshark.cambridge.arm.com>
	<20140207180216.GP4250@linux.vnet.ibm.com>
	<1391992071.18779.99.camel@triegel.csb>
Date: Sun, 9 Feb 2014 16:56:26 -0800
X-Google-Sender-Auth: 3W8wPEa-zcdE2SC-JaOO91otoeg
Message-ID: <CA+55aFwFVr2KiXX2MObMBGypQk9eabe-93Nhmro=HL1RtC-1jw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
>
> I wouldn't characterize the situation like this (although I can't speak
> for others, obviously).  IMHO, it's perfectly fine on sequential /
> non-synchronizing code, because we know the difference isn't observable
> by a correct program.

What BS is that? If you use an "atomic_store_explicit()", by
definition you're either

 (a) f*cking insane
 (b) not doing sequential non-synchronizing code

and a compiler that assumes that the programmer is insane may actually
be correct more often than not, but it's still a shit compiler.
Agreed?

So I don't see how any sane person can say that speculative writes are
ok. They are clearly not ok.

Speculative stores are a bad idea in general. They are completely
invalid for anything that says "atomic". This is not even worth
discussing.

                Linus
