Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3LJIcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:32:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3LJIAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 23/52] SCSI: hpsa: do not discard scsi status on aborted commands
Date: Tue, 10 Dec 2013 00:00:56 -0800
Message-Id: <20131210075955.830492329@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 2e311fbabdc23b7eaec77313dc3b9a151a5407b5 upstream.

We inadvertantly discarded the scsi status for aborted commands.
For some commands (e.g. reads from tape drives) these can't be retried,
and if we discarded the scsi status, the scsi mid layer couldn't notice
anything was wrong and the error was not reported.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1265,7 +1265,7 @@ static void complete_scsi_command(struct
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */


