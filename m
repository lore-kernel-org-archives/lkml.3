Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3IVRsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34577 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3IVRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:48:53 -0400
Message-ID: <523F2D21.5070505@zytor.com>
Date: Sun, 22 Sep 2013 10:47:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com> <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com> <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de> <20130920162603.GA30381@localhost.localdomain> <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com> <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com> <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com> <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop> <20130922162410.GA10649@laptop.programming.kicks-ass.net>
In-Reply-To: <20130922162410.GA10649@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 09:24 AM, Peter Zijlstra wrote:
> 
> As to the problem of GCC moving r13 about, some archs have some
> exceptions in the register allocator and leave some registers alone.
> IIRC MIPS has this and uses one of those (istr there's 2) for the
> per cpu base address.
> 

You can force gcc to leave a register alone with the command line option
-ffixed-r13.

	-hpa

