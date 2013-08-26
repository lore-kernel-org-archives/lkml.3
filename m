Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3HZWVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:21:42 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41760 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3HZWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:19:15 -0400
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
Subject: [PATCH-v2 1/9] target: Make target_core_subsystem defined as non static
Date: Mon, 26 Aug 2013 22:03:00 +0000
Message-Id: <1377554588-28394-2-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch makes the top-level target_core_subsystem array available
to other target code, which is required by EXTENDED_COPY to pin the
backend se_device using configfs_depend_item(), in order to ensure
it can't be removed for the duration of a EXTENDED_COPY operation.

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
 drivers/target/target_core_configfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 24517d4..939ecc5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -268,7 +268,7 @@ static struct configfs_subsystem target_core_fabrics = {
 	},
 };
 
-static struct configfs_subsystem *target_core_subsystem[] = {
+struct configfs_subsystem *target_core_subsystem[] = {
 	&target_core_fabrics,
 	NULL,
 };
-- 
1.7.2.5

