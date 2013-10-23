Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3JWHJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:09:56 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63961 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3JWHJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131022211237.GH2490@laptop.programming.kicks-ass.net>
References: <20131016205227.GJ7456@tassilo.jf.intel.com>
	<20131016210319.GI10651@twins.programming.kicks-ass.net>
	<20131016230712.GC26785@twins.programming.kicks-ass.net>
	<20131017094145.GE3364@laptop.programming.kicks-ass.net>
	<20131017160034.GO227855@redhat.com>
	<20131017160439.GP227855@redhat.com>
	<20131017163039.GR10651@twins.programming.kicks-ass.net>
	<CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
	<20131017220156.GB10651@twins.programming.kicks-ass.net>
	<CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
	<20131022211237.GH2490@laptop.programming.kicks-ass.net>
Date: Wed, 23 Oct 2013 08:09:53 +0100
X-Google-Sender-Auth: h4UeQmeGF1uk4pk494ZaMTl-flc
Message-ID: <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Careful! There is one magic piece of state that you need to
>> save-and-restore if you do this, namely %cr2. Taking a page fault
>> always writes to %cr2, and we must *not* corrupt it in the NMI
>> handler.
>
> It looks like this is already dealt with (a similar thing is done for
> i386).

Oh, ok then, we should be good to go. I wonder why we needed that
special "_nmi()" version, then..

Please do check that NMI increment the irq-counts etc.. Otherwise
you'll need to add the explicit "pagefault_disable/enable()" pair
around the __copy_from_user_inatomic()..

            Linus
