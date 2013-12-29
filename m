Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3L2ClP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:41:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55341 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab3L2CKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:34 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.388376967@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/185] [SCSI] hpsa: do not discard scsi status on
 aborted commands
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 2e311fbabdc23b7eaec77313dc3b9a151a5407b5 upstream.

We inadvertantly discarded the scsi status for aborted commands.
For some commands (e.g. reads from tape drives) these can't be retried,
and if we discarded the scsi status, the scsi mid layer couldn't notice
anything was wrong and the error was not reported.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1186,7 +1186,7 @@ static void complete_scsi_command(struct
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */

