Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422927Ab3DFNkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:40:10 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:48984 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422889Ab3DFNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:40:08 -0400
Date: Sat, 6 Apr 2013 15:39:59 +0200
From: Robert Richter <rric.net@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Subject: [GIT PULL] oprofile updates for v3.10
Message-ID: <20130406133959.GA11652@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 1.7.7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull updates for 3.10 (tip/perf/core):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip

Just one trivial patch.

Thanks,

-Robert



The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master

for you to fetch changes up to 23995bbee01d75f09f72b1380bd6045a5b02947b:

  oprofile, s390: Add support for IBM zEnterprise EC12 (2013-04-06 15:25:42 +0200)

----------------------------------------------------------------
Andreas Krebbel (1):
      oprofile, s390: Add support for IBM zEnterprise EC12

 arch/s390/oprofile/init.c | 1 +
 1 file changed, 1 insertion(+)




>From 23995bbee01d75f09f72b1380bd6045a5b02947b Mon Sep 17 00:00:00 2001
From: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Date: Wed, 9 Jan 2013 10:13:55 +0100
Subject: [PATCH] oprofile, s390: Add support for IBM zEnterprise EC12

This patch adds support for the latest release of the
IBM mainframe series - the IBM zEnterprise EC12 (zEC12).

The CPU measurement facility didn't change.  So only the new CPU type
has to be tolerated.

Signed-off-by: Andreas Krebbel <krebbel@linux.vnet.ibm.com>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/s390/oprofile/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 584b936..ffeb17c 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -440,6 +440,7 @@ static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 		switch (id.machine) {
 		case 0x2097: case 0x2098: ops->cpu_type = "s390/z10"; break;
 		case 0x2817: case 0x2818: ops->cpu_type = "s390/z196"; break;
+		case 0x2827:              ops->cpu_type = "s390/zEC12"; break;
 		default: return -ENODEV;
 		}
 	}
-- 
1.8.1.1

