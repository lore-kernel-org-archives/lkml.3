Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaLEXxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:53:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaLEWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 020/122] inetdevice: fixed signed integer overflow
Date: Fri,  5 Dec 2014 14:43:14 -0800
Message-Id: <20141205223308.498849992@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>

[ Upstream commit 84bc88688e3f6ef843aa8803dbcd90168bb89faf ]

There could be a signed overflow in the following code.

The expression, (32-logmask) is comprised between 0 and 31 included.
It may be equal to 31.
In such a case the left shift will produce a signed integer overflow.
According to the C99 Standard, this is an undefined behavior.
A simple fix is to replace the signed int 1 with the unsigned int 1U.

Signed-off-by: Vincent BENAYOUN <vincent.benayoun@trust-in-soft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/inetdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -242,7 +242,7 @@ static inline void in_dev_put(struct in_
 static __inline__ __be32 inet_make_mask(int logmask)
 {
 	if (logmask)
-		return htonl(~((1<<(32-logmask))-1));
+		return htonl(~((1U<<(32-logmask))-1));
 	return 0;
 }
 


