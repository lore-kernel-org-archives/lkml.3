Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaJIKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:25:26 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:51001 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaJIKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:25:20 -0400
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Masaru Nomura <massa.nomura@gmail.com>,
        Peng Tao <bergwolf@gmail.com>, Chi Pham <fempsci@gmail.com>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH resend] staging, lustre: fix a sparse error
Date: Thu,  9 Oct 2014 18:25:10 +0800
Message-Id: <1412850311-5727-1-git-send-email-wangchao19890207@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse error:

drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c:393:9: error:
incompatible types in comparison expression (different address spaces)

Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
index 245c9d7..1510594 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
@@ -390,7 +390,7 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
 	__u32	csum;
 	void	*base;
 
-	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
+	LASSERT((void __force *) tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
 	LASSERT(tx->tx_conn != NULL);
 	LASSERT(tx->tx_conn->ksnc_proto == &ksocknal_protocol_v2x);
 
-- 
1.9.3

