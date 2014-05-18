Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaERQIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:08:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62196 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaERQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:08:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: dc395x.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:09:09 +0200
Message-Id: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 83d9bf6..0d86bc7 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 	struct ScsiReqBlk *srb = NULL;
 	struct ScsiReqBlk *i;
 	dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
-		   srb->cmd, tag, srb);
+		   srb ? srb->cmd : 0, tag, srb);
 
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
-- 
1.7.10.4

