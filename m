Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaHRJgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaHRJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/137] iovec: make sure the caller actually wants anything in memcpy_fromiovecend
Date: Mon, 18 Aug 2014 10:33:17 +0100
Message-Id: <1408354398-10226-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 06ebb06d49486676272a3c030bfeef4bd969a8e6 upstream.

Check for cases when the caller requests 0 bytes instead of running off
and dereferencing potentially invalid iovecs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: file rename: lib/iovec.c -> net/core/iovec.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/iovec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/iovec.c b/net/core/iovec.c
index 2145b7150beb..1117a26a8548 100644
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

