Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3DORMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:12:31 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41698 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729Ab3DORM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:12:29 -0400
Date: Mon, 15 Apr 2013 12:12:25 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Robin Holt <holt@sgi.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch -v3 0/4] Shutdown from reboot_cpuid without stopping other
 cpus.
Message-ID: <20130415171225.GC3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
reboot_cpuid and then continuing with shutdown/reboot.

The patch set is broken into four parts.  The first is planned for
the stable release.  The others move the halt/shutdown/reboot related
files to their own kernel/reboot.c file and then introduce the kernel
boot parameter.
