Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbaIOXVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:21:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaIOWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/187] iovec: make sure the caller actually wants anything in memcpy_fromiovecend
Date: Mon, 15 Sep 2014 15:07:00 -0700
Message-Id: <1410818997-9432-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 06ebb06d49486676272a3c030bfeef4bd969a8e6 ]

Check for cases when the caller requests 0 bytes instead of running off
and dereferencing potentially invalid iovecs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/iovec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/iovec.c b/net/core/iovec.c
index a9c46ba..26dc006 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -107,6 +107,10 @@ EXPORT_SYMBOL(memcpy_toiovecend);
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			int offset, int len)
 {
+	/* No data? Done! */
+	if (len == 0)
+		return 0;
+
 	/* Skip over the finished iovecs */
 	while (offset >= iov->iov_len) {
 		offset -= iov->iov_len;
-- 
1.9.1

