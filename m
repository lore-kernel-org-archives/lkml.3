Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbaISPch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:37 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:57382 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaISPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:32:35 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 0/3] Early boot self tests for RCU
Date: Fri, 19 Sep 2014 11:32:28 -0400
Message-Id: <1411140752-27028-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Please find v2 of the RCU early boot tests. For now
all we do in these tests are enqueue test callbacks and check if they are being
invoked or not.

I was able to reproduce the hang which Amit reported after reverting the fix. So
this should catch such errors if they occur in the future.

I enabled the selftests in a few rcutorture configurations.

Thanks!
--
Pranith

v2: removed srcu tests and updated according to feedback

Pranith Kumar (3):
  rcu: Add early boot self tests
  doc: Document RCU self test boot params
  rcutorture: Enable RCU self test in configs

 Documentation/kernel-parameters.txt                |  9 +++
 kernel/rcu/rcu.h                                   |  2 +
 kernel/rcu/tiny.c                                  |  4 +-
 kernel/rcu/tree.c                                  |  2 +
 kernel/rcu/update.c                                | 82 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/rcu/TINY02        |  2 +
 .../selftests/rcutorture/configs/rcu/TINY02.boot   |  2 +
 .../selftests/rcutorture/configs/rcu/TREE05.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TREE06.boot   |  3 +
 .../selftests/rcutorture/configs/rcu/TREE08        |  2 +
 .../selftests/rcutorture/configs/rcu/TREE08.boot   |  2 +
 11 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot

-- 
2.1.0

