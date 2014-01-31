Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaAaLab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:30:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaAaLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:30:29 -0500
Date: Fri, 31 Jan 2014 12:30:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: George Spelvin <linux@horizon.com>
Cc: Waiman.Long@hp.com, akpm@linux-foundation.org, andi@firstfloor.org,
        arnd@arndb.de, aswin@hp.com, hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, tim.c.chen@linux.intel.com,
        torvalds@linux-foundation.org, walken@google.com, x86@kernel.org
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140131113003.GC3229@twins.programming.kicks-ass.net>
References: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
 <20140131100348.8867.qmail@science.horizon.com>
 <20140131101729.GA8874@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131101729.GA8874@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 11:17:29AM +0100, Peter Zijlstra wrote:
> My main point was that we should seriously look at a ticket lock instead
> of the MCS one, because while the MCS has better contention behaviour,
> we shouldn't optimize locks for the worst contention.

In fact, I should have just used arch_spinlock_t and assumed it is a
ticket lock.
