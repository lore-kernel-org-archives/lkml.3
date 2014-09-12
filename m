Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaILDlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:41:47 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58908 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaILDlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:46 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net
Subject: [PATCH -tip 0/9] locktorture: Improve and expand lock torturing
Date: Thu, 11 Sep 2014 20:40:15 -0700
Message-Id: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set includes general updates throughout the locktorture code.
Particularly support for reader locks are added as well as torturing
mutexes and rwsems. With the recent locking changes, it doesn't hurt
to improve our testing infrastructure, and torturing is definitely
one of them. For specific details about each change, please consult
the actual patches.

o patches 1, 4, 9: misc changes.
o patch 2: new doc, based on rcutorture's.
o patches 3, 8: torture new locking primitives.
o patches 5, 7: add support for reader locks.
o patch 6: fix a minor race in the torture cleanup path.

Really no particular order, please consider for v3.18.

Davidlohr Bueso (9):
  locktorture: Rename locktorture_runnable parameter
  locktorture: Add documentation
  locktorture: Support mutexes
  locktorture: Teach about lock debugging
  locktorture: Make statistics generic
  torture: Address race in module cleanup
  locktorture: Add infraestructure for torturing read locks
  locktorture: Support rwsems
  locktorture: Introduce torture context

 Documentation/locking/locktorture.txt | 140 ++++++++++++
 include/linux/torture.h               |   3 +-
 kernel/locking/locktorture.c          | 392 ++++++++++++++++++++++++++++------
 kernel/rcu/rcutorture.c               |   3 +-
 kernel/torture.c                      |  16 +-
 5 files changed, 480 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/locking/locktorture.txt

-- 
1.8.4.5

