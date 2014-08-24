Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaHXWn1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 18:43:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbaHXWn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 18:43:26 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Aug 2014 08:42:35 +1000
Subject: [PATCH 0/6] Teach autofs about RCU-walk
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140824223628.16196.5795.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
 this series teaches autofs about RCU-walk so that we don't drop
 straight into REF-walk when we hit an autofs directory, and so that
 we avoid spinlocks as much as possible when performing an RCU-walk.

 This is needed so that the benefits of the recent NFS support for
 RCU-walk are fully available when NFS filesystems are automounted.

 Patches have been carefully reviewed and tested both with test suites
 and in production - thanks a lot to Ian Kent for his support there.

 If they could be queued for 3.18, I would appreciate it.

Thanks,
NeilBrown

---

NeilBrown (6):
      autofs4: allow RCU-walk to walk through autofs4.
      autofs4: factor should_expire() out of autofs4_expire_indirect.
      autofs4: make "autofs4_can_expire" idempotent.
      autofs4: avoid taking fs_lock during rcu-walk
      autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.
      autofs: the documentation I wanted to read


 Documentation/filesystems/autofs4.txt |  520 +++++++++++++++++++++++++++++++++
 fs/autofs4/autofs_i.h                 |    6 
 fs/autofs4/dev-ioctl.c                |    2 
 fs/autofs4/expire.c                   |  210 ++++++++-----
 fs/autofs4/root.c                     |   62 +++-
 5 files changed, 698 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/filesystems/autofs4.txt

-- 
Signature

