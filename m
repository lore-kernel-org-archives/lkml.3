Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaHHVgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:36:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532AbaHHVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:35:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 09/23] iovec: make sure the caller actually wants anything in memcpy_fromiovecend
Date: Fri,  8 Aug 2014 14:34:54 -0700
Message-Id: <20140808213316.160523609@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213315.769217722@linuxfoundation.org>
References: <20140808213315.769217722@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 06ebb06d49486676272a3c030bfeef4bd969a8e6 ]

Check for cases when the caller requests 0 bytes instead of running off
and dereferencing potentially invalid iovecs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/iovec.c |    4 ++++
 1 file changed, 4 insertions(+)

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


