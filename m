Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaJRUuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 16:50:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48478 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaJRUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 16:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <1413662314.17869.11.camel@linux-t7sj.site>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	<1413617580.29249.9.camel@linux-t7sj.site>
	<1413662314.17869.11.camel@linux-t7sj.site>
Date: Sat, 18 Oct 2014 13:50:18 -0700
X-Google-Sender-Auth: bi1Pl_NgiuCt7_tPFSnocvmIGk8
Message-ID: <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a barrier
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 12:58 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> And [get/put]_futex_keys() shouldn't even be called for private futexes.
> The following patch had some very minor testing on a 60 core box last
> night, but passes both Darren's and perf's tests. So I *think* this is
> right, but lack of sleep and I overall just don't trust them futexes!

Hmm. I don't see the advantage of making the code more complex in
order to avoid the functions that are no-ops for the !fshared case?

IOW, as far as I can tell, this patch doesn't actually really *change*
anything. Am I missing something?

         Linus
