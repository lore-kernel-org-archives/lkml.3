Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3LSL5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3LSL5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/208] [SCSI] hpsa: do not discard scsi status on aborted commands
Date: Thu, 19 Dec 2013 11:52:53 +0000
Message-Id: <1387454106-19326-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 2e311fbabdc23b7eaec77313dc3b9a151a5407b5 upstream.

We inadvertantly discarded the scsi status for aborted commands.
For some commands (e.g. reads from tape drives) these can't be retried,
and if we discarded the scsi status, the scsi mid layer couldn't notice
anything was wrong and the error was not reported.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 737af7e..05929a3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1266,7 +1266,7 @@ static void complete_scsi_command(struct CommandList *cp)
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */
-- 
1.8.3.2

