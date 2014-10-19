Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaJSCQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 22:16:36 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:35121 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbaJSCQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 22:16:35 -0400
Message-ID: <1413684978.17869.18.camel@linux-t7sj.site>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
From: Davidlohr Bueso <dave@stgolabs.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Date: Sat, 18 Oct 2014 19:16:18 -0700
In-Reply-To: <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	 <1413617580.29249.9.camel@linux-t7sj.site>
	 <1413662314.17869.11.camel@linux-t7sj.site>
	 <CA+55aFzmsF4F-SOO4OzZDbreaQ4X4RUCQksv_ONu59BbyZ8Ocg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 13:50 -0700, Linus Torvalds wrote:
> On Sat, Oct 18, 2014 at 12:58 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
> >
> > And [get/put]_futex_keys() shouldn't even be called for private futexes.
> > The following patch had some very minor testing on a 60 core box last
> > night, but passes both Darren's and perf's tests. So I *think* this is
> > right, but lack of sleep and I overall just don't trust them futexes!
> 
> Hmm. I don't see the advantage of making the code more complex in
> order to avoid the functions that are no-ops for the !fshared case?
> 
> IOW, as far as I can tell, this patch doesn't actually really *change*
> anything. Am I missing something?

Right, all we do is avoid a NOP, but I don't see how this patch makes
the code more complex. In fact, the whole idea is to make it easier to
read and makes the key referencing differences between shared and
private futexes crystal clear, hoping to mitigate future bugs. 

Thanks,
Davidlohr

