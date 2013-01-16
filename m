Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab3APQHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab3APQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 158/222] staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
Date: Wed, 16 Jan 2013 13:55:58 -0200
Message-Id: <1358351822-7675-159-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ab1dd9963137a1e122004d5378a581bf16ae9bc8 upstream.

Calling RFbSetPower with uCH zero value will cause out of bound array reference.

This causes 64 bit kernels to oops on boot.

Note: Driver does not function on 64 bit kernels and should be
blacklisted on them.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/vt6656/rf.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3fd0478..8cf0881 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr = pDevice->byCCKPwr;
         return TRUE;
     }
 
+	if (uCH == 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:
-- 
1.7.9.5

