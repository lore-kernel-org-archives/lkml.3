Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaEIKM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:12:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45365 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbaEIKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:19 -0400
X-Sasl-enc: bmu2TQj6EotnNBoPmQofFesSk86BIVYKuBRjo5pcPk2p 1399630158
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 03/10] staging: gdm72xx: Modify a struct allocation to match coding standards
Date: Fri,  9 May 2014 18:08:22 +0800
Message-Id: <1399630109-18701-3-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

CHECK: Prefer kmalloc(sizeof(*entry)...) over kmalloc(sizeof(struct qos_entry_s)...)

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 50d43ad..519db48 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -56,7 +56,7 @@ static void *alloc_qos_entry(void)
 	}
 	spin_unlock_irqrestore(&qos_free_list.lock, flags);
 
-	entry = kmalloc(sizeof(struct qos_entry_s), GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	return entry;
 }
 
-- 
1.8.4

