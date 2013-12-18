Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3LRUQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:16:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:23121 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3LRUQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:16:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,509,1384329600"; 
   d="scan'208";a="426820599"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
	<1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
	<20131217192128.GA15969@linux.vnet.ibm.com>
	<CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
	<878uvilzka.fsf@tassilo.jf.intel.com>
	<20131218194615.GG16438@laptop.programming.kicks-ass.net>
Date: Wed, 18 Dec 2013 12:16:11 -0800
In-Reply-To: <20131218194615.GG16438@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 18 Dec 2013 20:46:15 +0100")
Message-ID: <87zjnxlxtg.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Dec 18, 2013 at 11:38:29AM -0800, Andi Kleen wrote:
>> (maybe it would be time to get rid of the patchable LOCK though?)
>
> With the argument that Intel simply doesn't ship UP chips anymore, with
> the exception of quark which should probably run custom UP kernels due
> to size constraints anyway?

That, and:

- Anything with a single core only has very fast LOCK
- LOCK generally became much faster everywhere.
- The original reason was for single cpu VM guests, but even those
should increasingly have at least two VCPUs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
