Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3AKQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:47:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38059 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3AKQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:47:39 -0500
Date: Fri, 11 Jan 2013 08:08:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: paul.gortmaker@windriver.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [GIT PULL rcu/urgent] Fixes for RCU regressions in 3.8
Message-ID: <20130111160813.GA14503@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011116-5406-0000-0000-00000415B3C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Paul Gortmaker found some problems with no-CBs-CPU support in 3.8
mainline, and kindly supplied fixes.  The first problem is soft-lockup
complaints that can occur on systems running with no-CBs CPUs that have
long periods of time where RCU is completely idle, which can happen on
some embedded systems.  The second problem is a documentation error
for the "rcutree.rcu_nocb_poll" boot parameter.  In this case, Paul Gortmaker
(rightly) noted that the need for "rcutree." was inconsistent with the
"rcu_nocbs=<cpumap>" boot parameter.  The fix therefore to make the boot
parameter named "rcu_nocb_poll".

These problems only affect kernels built with the new CONFIG_RCU_NOCB_CPU
kernel parameter, but still should be fixed.

These fixes are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

------------------>
Paul Gortmaker (2):
      rcu: Prevent soft-lockup complaints about no-CBs CPUs
      rcu: Make rcu_nocb_poll an early_param instead of module_param

 Documentation/kernel-parameters.txt |    2 +-
 kernel/rcutree_plugin.h             |   13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

