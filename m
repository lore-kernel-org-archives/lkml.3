Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaATTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:31:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:11936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATTbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:31:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,691,1384329600"; 
   d="scan'208";a="469666178"
Subject: Re: [PATCH v7 1/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <20140120120756.GB31570@twins.programming.kicks-ass.net>
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
	 <1389917296.3138.11.camel@schen9-DESK>
	 <20140120120756.GB31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jan 2014 11:31:31 -0800
Message-ID: <1390246291.3138.31.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 13:07 +0100, Peter Zijlstra wrote:
> On Thu, Jan 16, 2014 at 04:08:16PM -0800, Tim Chen wrote:
> > +/*
> > + * We don't inline mcs_spin_lock() so that perf can correctly account for the
> > + * time spent in this lock function.
> > + */
> > +static noinline
> > +void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> 
> But given a vmlinux with sufficient DWARFs in, the IP will resolve to a
> .ista. symbol, no?

I'm actually only renaming the mspin_lock code to mcs_spin_lock here
and moving the code to header file.
The noinline logic was in the original code.  Later on when we move 
mcs_spin_lock to its own file and exporting the symbol, then I 
think this issue will be resolved.

Tim

