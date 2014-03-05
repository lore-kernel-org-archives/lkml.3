Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaCES6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:58:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaCES6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:58:31 -0500
From: Colin King <colin.king@canonical.com>
To: skinsbursky@parallels.com, linux-kernel@vger.kernel.org
Subject: [PATCH][v2] selftests: ipc: handle msgget failure return correctly
Date: Wed,  5 Mar 2014 18:58:28 +0000
Message-Id: <1394045908-9031-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A failed msgget causes the test to return an uninitialised value
in ret. Assign ret to -errno on error exit.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/ipc/msgque.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index d664182..aa290c0 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -201,6 +201,7 @@ int main(int argc, char **argv)
 
 	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
 	if (msgque.msq_id == -1) {
+		err = -errno;
 		printf("Can't create queue\n");
 		goto err_out;
 	}
-- 
1.9.0

