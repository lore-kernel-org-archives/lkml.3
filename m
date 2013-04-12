Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3DLXiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:38:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49474 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3DLXiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:38:21 -0400
Date: Fri, 12 Apr 2013 16:38:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/2] SRCU changes for 3.11
Message-ID: <20130412233815.GA22914@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5806-0000-0000-000020B6260D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides some SRCU changes:

1.	Remove srcu_read_lock_raw() and srcu_read_unlock_raw().  These
	never did get used, and have not been used for some time, so
	it is time for them to go.

2.	Fix a bug where srcu_read_lock() is not released upon return
	from kvmppc_hv_setup_htab_rma().

							Thanx, Paul


 b/Documentation/RCU/checklist.txt |    6 -----
 b/Documentation/RCU/torture.txt   |    6 -----
 b/Documentation/RCU/whatisRCU.txt |   22 ++++++-------------
 b/arch/powerpc/kvm/book3s_hv.c    |    2 -
 b/include/linux/srcu.h            |   43 --------------------------------------
 b/kernel/rcutorture.c             |   39 ----------------------------------
 6 files changed, 8 insertions(+), 110 deletions(-)

