Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3KRSen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:34:43 -0500
Received: from one.firstfloor.org ([193.170.194.197]:52104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3KRSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:34:38 -0500
Date: Mon, 18 Nov 2013 19:34:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v6 3/5] qrwlock: Enable fair queue read/write lock
Message-ID: <20131118183433.GB29695@two.firstfloor.org>
References: <1384267735-43213-1-git-send-email-Waiman.Long@hp.com>
 <1384267735-43213-5-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXu7eC1WGfZ=_JQbLLJHM5HYRkJPjm3jBDC51SL66Ecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxXu7eC1WGfZ=_JQbLLJHM5HYRkJPjm3jBDC51SL66Ecw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:11:48AM -0800, Linus Torvalds wrote:
> On Tue, Nov 12, 2013 at 6:48 AM, Waiman Long <Waiman.Long@hp.com> wrote:
> > By default, queue rwlock is fair among writers and gives preference
> > to readers allowing them to steal lock even if a writer is
> > waiting. However, there is a desire to have a fair variant of
> > rwlock that is more deterministic. To enable this [..]
> 
> Is there really any point in having the option for unfair at all?

FWIW unfair can be faster in some cases. It depends on the workload.

The fair lock doesn't know anything about the topology of the system,
so it will happily spread queuers over all sockets or cores, no
matter how long the latency is.

An unfair lock can do things like "short cut to a very nearby thread".

Some unfairness tends to help with very small critical regions,
when you're not too much contended.

I would assume in cases where we don't expect all CPUs to bang 
on a lock it could be a good idea.

-Andi
