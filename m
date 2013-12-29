Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3L2Cbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:31:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55457 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab3L2CKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Eric Seppanen" <eric@purestorage.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.406735274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 082/185] iscsi-target: fix extract_param to handle
 buffer length corner case
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Seppanen <eric@purestorage.com>

commit 369653e4fb511928511b0ce81f41c812ff1f28b6 upstream.

extract_param() is called with max_length set to the total size of the
output buffer.  It's not safe to allow a parameter length equal to the
buffer size as the terminating null would be written one byte past the
end of the output buffer.

Signed-off-by: Eric Seppanen <eric@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -89,7 +89,7 @@ int extract_param(
 	if (len < 0)
 		return -1;
 
-	if (len > max_length) {
+	if (len >= max_length) {
 		pr_err("Length of input: %d exeeds max_length:"
 			" %d\n", len, max_length);
 		return -1;

