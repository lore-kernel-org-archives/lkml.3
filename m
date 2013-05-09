Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3EIIAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:00:05 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44447 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3EIIAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:00:02 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 04/21] NFC: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 11:58:26 +0400
Message-Id: <1368086323-9412-4-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 net/nfc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 40d2527..1c4b513 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -701,7 +701,7 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 }
 EXPORT_SYMBOL(nfc_target_lost);
 
-inline void nfc_driver_failure(struct nfc_dev *dev, int err)
+void nfc_driver_failure(struct nfc_dev *dev, int err)
 {
 	nfc_targets_found(dev, NULL, 0);
 }
-- 
1.8.1.4

