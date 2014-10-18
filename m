Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaJRQPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 12:15:36 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34942 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaJRQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 12:15:35 -0400
Message-ID: <1413648929.5367.25.camel@marge.simpson.net>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Franchin <Matteo.Franchin@arm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 18 Oct 2014 18:15:29 +0200
In-Reply-To: <CA+55aFydqk0NVcYHForRCXVJj_Tw+T+ZW9GikAmUXdOgdpGf5A@mail.gmail.com>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	 <1413615285.5741.41.camel@marge.simpson.net>
	 <CA+55aFydqk0NVcYHForRCXVJj_Tw+T+ZW9GikAmUXdOgdpGf5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 08:28 -0700, Linus Torvalds wrote: 
> On Fri, Oct 17, 2014 at 11:54 PM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> >
> > The barrier fixing up my problematic box smells a lot like evidence.
> 
> Is this a "tested-by"? Did you actuallyu verify that the patch ends up
> fixing the problem you saw?

Yup, it definitely fixed it up.

Weird that it didn't show at all on the 2 socket 20 core box the problem
I was looking into was reported on, but was 100% busted on the similar 2
socket 28 core box I borrowed to have a peek, and only that box.  My
(crippled/slow) 64 core DL980 was perfectly happy, as were my 3 home
boxen, not a peep from anywhere but that one 28 core box.

Hohum..  Tested-by: Mike Galbraith <umgwanakikbuti@gmail.com>

-Mike

