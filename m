Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3EIJUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:20:50 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64812 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3EIJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:20:49 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Marc Dietrich <marvin24@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 06/21] staging: nvec: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 13:19:37 +0400
Message-Id: <1368091192-10245-1-git-send-email-yefremov.denis@gmail.com>
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
 drivers/staging/nvec/nvec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index a88959f..954c992 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -185,7 +185,7 @@ static struct nvec_msg *nvec_msg_alloc(struct nvec_chip *nvec,
  *
  * Free the given message
  */
-inline void nvec_msg_free(struct nvec_chip *nvec, struct nvec_msg *msg)
+void nvec_msg_free(struct nvec_chip *nvec, struct nvec_msg *msg)
 {
 	if (msg != &nvec->tx_scratch)
 		dev_vdbg(nvec->dev, "INFO: Free %ti\n", msg - nvec->msg_pool);
-- 
1.8.1.4

