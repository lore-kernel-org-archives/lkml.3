Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaAUPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:50:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58739 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAUPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:50:30 -0500
Date: Tue, 21 Jan 2014 16:49:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 4/5] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140121154954.GC31570@twins.programming.kicks-ass.net>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
 <1389761047-47566-5-git-send-email-Waiman.Long@hp.com>
 <20140120151855.GH30183@twins.programming.kicks-ass.net>
 <52DE9626.3030806@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE9626.3030806@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:45:42AM -0500, Waiman Long wrote:
> I can change the logic to use only cmpxchg for readers, but I don't see a
> compelling reason to do so.

The fact that you can then use smp_store_release() is fairly compelling
methinks.
