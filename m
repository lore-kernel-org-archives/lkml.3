Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaI2NPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:15:00 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34948 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbaI2NO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:14:59 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, dave@stgolabs.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] locktorture: Torture rwlocks
Date: Mon, 29 Sep 2014 06:14:22 -0700
Message-Id: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are still missing the ability to torture rwlocks, particularly the
new queued variant (patch 1). The rest of the patches are miscellaneous
updates.

Hopefully the set is straightforward enough that it can still be
considered for v3.18.

Davidlohr Bueso (4):
  locktorture: Support rwlocks
  locktorture: Fix __acquire annotation for spinlock irq
  locktorture: Cannot hold read and write lock
  locktorture: Cleanup header usage

 Documentation/locking/locktorture.txt              |   5 +
 kernel/locking/locktorture.c                       | 141 ++++++++++++++++++---
 .../selftests/rcutorture/configs/lock/CFLIST       |   1 +
 .../selftests/rcutorture/configs/lock/LOCK04       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
 5 files changed, 137 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot

-- 
1.8.4.5

