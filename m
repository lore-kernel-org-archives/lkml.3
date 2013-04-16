Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab3DPJ4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:56:45 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41140 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753749Ab3DPJ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:56:44 -0400
Date: Tue, 16 Apr 2013 04:56:41 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Robin Holt <holt@sgi.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch -v4 0/4] Shutdown from reboot_cpuid without stopping other
 cpus.
Message-ID: <20130416095641.GL3658@sgi.com>
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
functions to their own kernel/reboot.c file and then introduce the kernel
boot parameter.


Changes since -v3.
- Added a tested-by for the original reporter.
- Fix compile failure found by Joe Perches.
- Integrated comments by Joe Perches.
