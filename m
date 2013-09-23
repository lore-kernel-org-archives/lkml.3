Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3IWUwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:52:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:51595 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3IWUwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:52:51 -0400
Message-ID: <1379969467.11249.21.camel@pasglop>
Subject: Re: [PATCH] powerpc/irq: Run softirqs off the top of the irq stack
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 Sep 2013 06:51:07 +1000
In-Reply-To: <CA+55aFwcPU+fAqDGp0QhSYip7MYPBB+kQiU4GHEdgMo82i7RVg@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	 <1379889489.24090.34.camel@pasglop> <1379910958.6625.3.camel@pasglop>
	 <CA+55aFwcPU+fAqDGp0QhSYip7MYPBB+kQiU4GHEdgMo82i7RVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 09:47 -0700, Linus Torvalds wrote:
> On Sun, Sep 22, 2013 at 9:35 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > This is the "band aid" discussed so far for the stack overflow
> > problem for powerpc.
> 
> I don't think it's a "band-aid" in any way, except perhaps in the
> sense that there are certainly other things we can also do in this
> series (ie I liked Frederic's cleanups etc).

Ah yes, I thought of it as a band-aid in the sense that a better
approach would be to switch to the irq stack earlier like x86_64 does
but that would be a lot more invasive. Definitely something I would look
into if I was to tackle changing how we do per-cpu and the PACA though.

Cheers,
Ben.


