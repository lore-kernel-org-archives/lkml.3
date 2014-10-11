Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaJKVeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 17:34:18 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41803 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJKVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 17:34:16 -0400
From: Filipe Goncalves <filipe@codinghighway.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
Subject: [PATCH 1/1] drivers/staging: Removed unnecessary check for LUSTRE_VERSION_CODE
Date: Sat, 11 Oct 2014 22:33:39 +0100
Message-Id: <1413063219-11494-1-git-send-email-filipe@codinghighway.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Gonçalves <filipe@codinghighway.com>

Given that this code is now part of the kernel tree, the #ifdef directive comparing LUSTRE_VERSION_CODE to the kernel version is no longer needed.

As a side effect, this will also remove the sparse error "directive in argument list".

Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
---
 drivers/staging/lustre/lustre/ptlrpc/layout.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 5b83371..78364ec 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -980,18 +980,7 @@ EXPORT_SYMBOL(RMF_CONN);
 struct req_msg_field RMF_CONNECT_DATA =
 	DEFINE_MSGF("cdata",
 		    RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
-#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
 		    sizeof(struct obd_connect_data),
-#else
-/* For interoperability with 1.8 and 2.0 clients/servers.
- * The RPC verification code allows larger RPC buffers, but not
- * smaller buffers.  Until we no longer need to keep compatibility
- * with older servers/clients we can only check that the buffer
- * size is at least as large as obd_connect_data_v1.  That is not
- * not in itself harmful, since the chance of just corrupting this
- * field is low.  See JIRA LU-16 for details. */
-		    sizeof(struct obd_connect_data_v1),
-#endif
 		    lustre_swab_connect, NULL);
 EXPORT_SYMBOL(RMF_CONNECT_DATA);
 
-- 
1.9.1

