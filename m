Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbbAGRiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:38:52 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:55586 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAGRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:38:50 -0500
Date: Wed, 7 Jan 2015 09:38:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/3] SRCU changes for 3.20
Message-ID: <20150107173842.GA3240@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791E0CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains some minor changes to SRCU:

1.	Expand SRCU ->completed to 64 bits.  This is to be consistent with
	rcutorture, which now pays attention to this field for more precise
	error checking.

2.	Combine DEFINE_SRCU() and DEFINE_STATIC_SRCU().

3.	Make SRCU optional via a new CONFIG_SRCU Kconfig parameter,
	courtesy of Pranith Kumar.  This saves about 2KB.

								Thanx, Paul

------------------------------------------------------------------------

 b/arch/arm/kvm/Kconfig     |    1 +
 b/arch/arm64/kvm/Kconfig   |    1 +
 b/arch/mips/kvm/Kconfig    |    1 +
 b/arch/powerpc/kvm/Kconfig |    1 +
 b/arch/s390/kvm/Kconfig    |    1 +
 b/arch/tile/kvm/Kconfig    |    1 +
 b/arch/x86/Kconfig         |    1 +
 b/arch/x86/kvm/Kconfig     |    1 +
 b/drivers/clk/Kconfig      |    1 +
 b/drivers/cpufreq/Kconfig  |    1 +
 b/drivers/devfreq/Kconfig  |    1 +
 b/drivers/md/Kconfig       |    1 +
 b/drivers/net/Kconfig      |    1 +
 b/fs/btrfs/Kconfig         |    1 +
 b/fs/notify/Kconfig        |    1 +
 b/fs/quota/Kconfig         |    1 +
 b/include/linux/srcu.h     |   14 ++++++--------
 b/init/Kconfig             |    9 +++++++++
 b/kernel/notifier.c        |    3 +++
 b/kernel/power/Kconfig     |    1 +
 b/kernel/rcu/Makefile      |    3 ++-
 b/kernel/rcu/srcu.c        |    2 +-
 b/lib/Kconfig.debug        |    1 +
 b/mm/Kconfig               |    1 +
 b/security/tomoyo/Kconfig  |    1 +
 25 files changed, 41 insertions(+), 10 deletions(-)

