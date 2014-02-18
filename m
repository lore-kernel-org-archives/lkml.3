Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaBRHdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:33:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36399 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaBRHdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:33:51 -0500
Date: Tue, 18 Feb 2014 08:33:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140218073326.GX27965@twins.programming.kicks-ass.net>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
 <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:41:22PM -0500, Waiman Long wrote:
> +#define	_QCODE(lock)	(atomic_read(&(lock)->qlcode) >> _QCODE_OFFSET)
> +#define	_QLOCK(lock)	(atomic_read(&(lock)->qlcode) & _QSPINLOCK_LOCKED)

> +#define GET_QN_IDX(code)	(((code) >> _QCODE_VAL_OFFSET) & 3)
> +#define GET_CPU_NR(code)	(((code) >> (_QCODE_VAL_OFFSET + 2)) - 1)
> +#ifndef _SET_QCODE
> +#define _SET_QCODE(cpu, idx)	((((cpu) + 1) << (_QCODE_VAL_OFFSET + 2)) |\
> +				((idx) << _QCODE_VAL_OFFSET) |\


Someone please take the CPP away.. dude most this doesn't need to be a
macro. Its used only in 1 or two places and its utterly unreadable.
