Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHADBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 23:01:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45852 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaHADBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 23:01:15 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: davem@davemloft.net, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] iovec: make sure the caller actually wants anything in memcpy_fromiovecend
Date: Thu, 31 Jul 2014 23:00:35 -0400
Message-Id: <1406862035-27818-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for cases when the caller requests 0 bytes instead of running off
and dereferencing potentially invalid iovecs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 lib/iovec.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/iovec.c b/lib/iovec.c
index 7a7c2da..df3abd1 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -85,6 +85,10 @@ EXPORT_SYMBOL(memcpy_toiovecend);
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
1.7.10.4

