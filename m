Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaCUFYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:24:54 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:48412 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaCUFYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140321045501.GD30295@linux.vnet.ibm.com>
References: <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	<1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
	<1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
	<1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
	<20140321045501.GD30295@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 22:24:52 -0700
X-Google-Sender-Auth: wt472DuWJA4_cxz9_CKuwAKIjkY
Message-ID: <CA+55aFyX0sj_MjTas3RYWWOa1W-xc3t0Af_0vdmsmgui8Apqpw@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 9:55 PM, Srikar Dronamraju
<srikar@linux.vnet.ibm.com> wrote:
>
> I reverted commits 99b60ce6 and b0c29f79. Then applied the patches in
> the above url. The last one had a reject but it was pretty
> straightforward to resolve it. After this, specjbb completes.
>
> So reverting and applying v3 3/4 and 4/4 patches works for me.

Ok, I verified that the above endds up resulting in the same tree as
the minimal patch I sent out, modulo (a) some comments and (b) an
#ifdef CONFIG_SMP in futex_get_mm() that doesn't really matter.

So I committed the minimal patch with your tested-by.

             Linus
