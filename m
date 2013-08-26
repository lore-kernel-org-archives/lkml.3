Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3HZWUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:20:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63908 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3HZWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:19:23 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nicholas Bellinger <nab@daterainc.com>
Subject: [PATCH-v2 5/9] target: Avoid non-existent tg_pt_gp_mem in target_alua_state_check
Date: Mon, 26 Aug 2013 22:03:04 +0000
Message-Id: <1377554588-28394-6-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds an check for a non-existent port->sep_alua_tg_pt_gp_mem
within target_alua_state_check(), which is not present for internally
dispatched EXTENDED_COPY WRITE I/O to the destination target port.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_alua.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 5403186..ea928c4 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -557,6 +557,9 @@ target_alua_state_check(struct se_cmd *cmd)
 	 * a ALUA logical unit group.
 	 */
 	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
+	if (!tg_pt_gp_mem)
+		return 0;
+
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 	out_alua_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
-- 
1.7.2.5

