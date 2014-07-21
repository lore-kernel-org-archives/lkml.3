Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaGUVrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:47:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:33980 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaGUVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:47:21 -0400
Date: Mon, 21 Jul 2014 23:47:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
In-Reply-To: <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407212344130.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com> <CFF29A00.9D44A%dvhart@linux.intel.com> <CFF29E4A.9D44E%dvhart@linux.intel.com> <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop> <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Andy Lutomirski wrote:
> On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > All this is predicated on the fact that syscalls are 'expensive'.
> > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> > more expensive due to cacheline misses, which due to the size of the
> > things is almost guaranteed.
> 
> 120 - 300 cycles for me, unless tracing happens, and I'm working on
> reducing the incidence of tracing.

So it's a non issue indeed and definitely not worth the trouble of
that extra storage, the scheduler overhead, etc.

Summary: Once you can't take it atomically in user space, you've lost
	 anyway. And we are better off to do the magic spinning in
	 kernel where we have all the information accessible already.

Thanks,

	tglx
