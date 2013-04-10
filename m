Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936969Ab3DJKbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:31:52 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33010 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3DJKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:31:49 -0400
Date: Wed, 10 Apr 2013 12:31:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
Message-ID: <20130410103144.GC28505@gmail.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
 <1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
 <20130408124223.GA10093@gmail.com>
 <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
 <5163042F.9000404@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163042F.9000404@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> > That said, the MUTEX_SHOULD_XCHG_COUNT macro should die. Why shouldn't all 
> > architectures just consider negative counts to be locked? It doesn't matter 
> > that some might only ever see -1.
> 
> I think so too. However, I don't have the machines to test out other 
> architectures. The MUTEX_SHOULD_XCHG_COUNT is just a safety measure to make sure 
> that my code won't screw up the kernel in other architectures. Once it is 
> confirmed that a negative count other than -1 is fine for all the other 
> architectures, the macro can certainly go.

I'd suggest to just remove it in an additional patch, Cc:-ing 
linux-arch@vger.kernel.org. The change is very likely to be fine, if not then it's 
easy to revert it.

Thanks,

	Ingo
