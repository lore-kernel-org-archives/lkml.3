Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaIKNOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:14:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51517 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sasha Levin" <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.980946530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 106/131] iovec: make sure the caller actually wants
 anything in  memcpy_fromiovecend
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 06ebb06d49486676272a3c030bfeef4bd969a8e6 ]

Check for cases when the caller requests 0 bytes instead of running off
and dereferencing potentially invalid iovecs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/iovec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/iovec.c b/net/core/iovec.c
index fcf9ee7..66e3f1f 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -157,6 +157,10 @@ EXPORT_SYMBOL(memcpy_fromiovec);
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

