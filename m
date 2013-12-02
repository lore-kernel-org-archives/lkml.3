Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab3LBVG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:06:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3LBTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Seppanen <eric@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 049/173] iscsi-target: fix extract_param to handle buffer length corner case
Date: Mon,  2 Dec 2013 11:10:32 -0800
Message-Id: <20131202191148.281637207@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Seppanen <eric@purestorage.com>

commit 369653e4fb511928511b0ce81f41c812ff1f28b6 upstream.

extract_param() is called with max_length set to the total size of the
output buffer.  It's not safe to allow a parameter length equal to the
buffer size as the terminating null would be written one byte past the
end of the output buffer.

Signed-off-by: Eric Seppanen <eric@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -90,7 +90,7 @@ int extract_param(
 	if (len < 0)
 		return -1;
 
-	if (len > max_length) {
+	if (len >= max_length) {
 		pr_err("Length of input: %d exceeds max_length:"
 			" %d\n", len, max_length);
 		return -1;


