Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaIRDV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:21:56 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64630 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbaIRDVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:21:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] Early boot self tests for RCU
Date: Wed, 17 Sep 2014 23:21:46 -0400
Message-Id: <1411010509-31927-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
References: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Please find the following patches which enable RCU early boot tests. For now
all we do in these tests are enqueue test callbacks and check if they are being
invoked or not.

I was able to reproduce the hang which Amit reported after reverting the fix. So
this should catch such errors if they occur in the future.

I enabled the selftests in a few rcutorture configurations.

Thanks!
--
Pranith

Pranith Kumar (3):
  rcu: Add early boot self tests
  doc: Document RCU self test boot params
  rcutorture: Enable RCU self test in configs

 Documentation/kernel-parameters.txt                | 12 +++
 kernel/rcu/rcu.h                                   |  2 +
 kernel/rcu/tiny.c                                  |  4 +-
 kernel/rcu/tree.c                                  |  2 +
 kernel/rcu/update.c                                | 91 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/rcu/TINY02        |  2 +
 .../selftests/rcutorture/configs/rcu/TINY02.boot   |  2 +
 .../selftests/rcutorture/configs/rcu/TREE05.boot   |  1 +
 .../selftests/rcutorture/configs/rcu/TREE06.boot   |  4 +
 .../selftests/rcutorture/configs/rcu/TREE08        |  2 +
 .../selftests/rcutorture/configs/rcu/TREE08.boot   |  2 +
 11 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TINY02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE06.boot

-- 
2.1.0

