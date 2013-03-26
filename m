Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab3CZPwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:52:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965048Ab3CZPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>, David Howells <dhowells@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 063/150] key: Fix resource leak
Date: Tue, 26 Mar 2013 15:19:22 +0000
Message-Id: <1364311249-14454-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit a84a921978b7d56e0e4b87ffaca6367429b4d8ff upstream.

On an error iov may still have been reallocated and need freeing

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/keys/keyctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 0f5b3f0..44d8758 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1112,12 +1112,12 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret < 0)
-		return ret;
+		goto err;
 	if (ret == 0)
 		goto no_payload_free;
 
 	ret = keyctl_instantiate_key_common(id, iov, ioc, ret, ringid);
-
+err:
 	if (iov != iovstack)
 		kfree(iov);
 	return ret;
-- 
1.8.1.2

