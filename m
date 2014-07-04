Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbaGDToa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:44:30 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:61824 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821AbaGDTo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:44:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAOICt1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hDEvI4EaN4hGAbVPlSKFcIhRFE0dhC0FkAmKbZQMg0U7gTI
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/quota: kernel-doc warning fixes
Date: Fri,  4 Jul 2014 21:44:25 +0200
Message-Id: <1404503065-32385-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

type and id were removed and qid added to quota_send_warning in commit

431f19744d15
("userns: Convert quota netlink aka quota_send_warning")

Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/quota/kqid.c    | 2 +-
 fs/quota/netlink.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/quota/kqid.c b/fs/quota/kqid.c
index 2f97b0e..ebc5e62 100644
--- a/fs/quota/kqid.c
+++ b/fs/quota/kqid.c
@@ -55,7 +55,7 @@ EXPORT_SYMBOL(qid_lt);
 /**
  *	from_kqid - Create a qid from a kqid user-namespace pair.
  *	@targ: The user namespace we want a qid in.
- *	@kuid: The kernel internal quota identifier to start with.
+ *	@kqid: The kernel internal quota identifier to start with.
  *
  *	Map @kqid into the user-namespace specified by @targ and
  *	return the resulting qid.
diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
index 72d2917..bb2869f 100644
--- a/fs/quota/netlink.c
+++ b/fs/quota/netlink.c
@@ -32,8 +32,7 @@ static struct genl_family quota_genl_family = {
 
 /**
  * quota_send_warning - Send warning to userspace about exceeded quota
- * @type: The quota type: USRQQUOTA, GRPQUOTA,...
- * @id: The user or group id of the quota that was exceeded
+ * @qid: The kernel internal quota identifier.
  * @dev: The device on which the fs is mounted (sb->s_dev)
  * @warntype: The type of the warning: QUOTA_NL_...
  *
-- 
1.9.1

