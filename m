Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab3LERpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:45:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab3LERhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Seppanen <eric@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 68/90] iscsi-target: fix extract_param to handle buffer length corner case
Date: Thu,  5 Dec 2013 17:35:50 +0000
Message-Id: <1386264972-5399-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Seppanen <eric@purestorage.com>

commit 369653e4fb511928511b0ce81f41c812ff1f28b6 upstream.

extract_param() is called with max_length set to the total size of the
output buffer.  It's not safe to allow a parameter length equal to the
buffer size as the terminating null would be written one byte past the
end of the output buffer.

Signed-off-by: Eric Seppanen <eric@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 0184bea..89f8909 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -89,7 +89,7 @@ int extract_param(
 	if (len < 0)
 		return -1;
 
-	if (len > max_length) {
+	if (len >= max_length) {
 		pr_err("Length of input: %d exceeds max_length:"
 			" %d\n", len, max_length);
 		return -1;
-- 
1.8.3.2

