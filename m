Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaICDnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:43:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42318 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaICDnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:43:52 -0400
Date: Tue, 2 Sep 2014 20:43:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: amit.shah@redhat.com, bobby.prani@gmail.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/urgent] Fix for 3.17
Message-ID: <20140903034346.GA17003@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090303-1542-0000-0000-0000047D5DD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series contains a single commit fixing an initialization bug
reported by Amit Shah and fixed by Pranith Kumar (and tested by Amit).
This bug results in a boot-time hang in callback-offloaded configurations
where callbacks were posted before the offloading ("rcuo") kthreads
were created.  This has been exposed to -next testing, and is available
in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

for you to fetch changes up to 11ed7f934cb807f26da09547b5946c2e534d1dac:

  rcu: Make nocb leader kthreads process pending callbacks after spawning (2014-08-28 05:59:59 -0700)

----------------------------------------------------------------
Pranith Kumar (1):
      rcu: Make nocb leader kthreads process pending callbacks after spawning

 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

