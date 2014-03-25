Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaCYEQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 00:16:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59397 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCYEQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 00:16:43 -0400
Date: Mon, 24 Mar 2014 21:16:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/next] Additional RCU commit for 3.15
Message-ID: <20140325041638.GA23624@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032504-0928-0000-0000-000000A89377
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

And, if you are willing to take it, one late-breaking commit.  This one
was requested for 3.15 by Peter Zijlstra.  It is low risk because it adds
a new in-kernel API with minimal changes to the existing code.  Those
minimal changes are the addition of memory barriers and ACCESS_ONCE()
macro calls, neither of which should be able to break things.  This commit
has passed significant rcutorture testing, with these additional additions
to rcutorture slated for 3.16.  This commit has also been exposed to
-next testing.

This change is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

for you to fetch changes up to 765a3f4fed708ae429ee095914a7897acb3a65bd:

  rcu: Provide grace-period piggybacking API (2014-03-20 17:12:25 -0700)

----------------------------------------------------------------
Paul E. McKenney (1):
      rcu: Provide grace-period piggybacking API

 include/linux/rcutiny.h | 10 ++++++++
 include/linux/rcutree.h |  2 ++
 kernel/rcu/tree.c       | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 70 insertions(+), 4 deletions(-)

