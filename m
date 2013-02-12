Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab3BLQtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:49:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36212 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BLQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:49:40 -0500
Date: Tue, 12 Feb 2013 08:29:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/srcu] SRCU commits for 3.9
Message-ID: <20130212162903.GA16750@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021216-2398-0000-0000-000010FC5411
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series contains SRCU changes for 3.9.  These include debugging aids,
updates that move towards the goal of permitting srcu_read_lock() and
srcu_read_unlock() to be used from idle and offline CPUs, and a few small
fixes.  These commits are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/srcu

							Thanx, Paul

-------------->
Lai Jiangshan (8):
      srcu: Simplify __srcu_read_unlock() via this_cpu_dec()
      srcu: Add might_sleep() annotation to synchronize_srcu()
      srcu: Simple cleanup for cleanup_srcu_struct()
      srcu: Remove checks preventing offline CPUs from calling srcu_read_lock()
      srcu: Remove checks preventing idle CPUs from calling srcu_read_lock()
      srcu: Update synchronize_srcu()'s comments
      srcu: Update synchronize_srcu_expedited()'s comments
      srcu: use ACCESS_ONCE() to access sp->completed in srcu_read_lock()

 include/linux/srcu.h |   26 +++-----------------------
 kernel/srcu.c        |   37 ++++++++++++++++---------------------
 2 files changed, 19 insertions(+), 44 deletions(-)

