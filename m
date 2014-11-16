Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaKPOjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 09:39:22 -0500
Received: from ygrex.ru ([5.19.241.250]:56400 "EHLO ygrex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbaKPOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 09:39:21 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2014 09:39:21 EST
Date: Sun, 16 Nov 2014 17:33:55 +0300
From: Igor Bogomazov <ygrex@ygrex.ru>
To: linux-kernel@vger.kernel.org
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: lustre: socklnd: sparse warning fix
Message-ID: <20141116173355.292a6d4a@ygrex-lenovo>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse reports the following issue:
drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c:393:9:
error: incompatible types in comparison expression (different address
spaces)

Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Igor Bogomazov <ygrex@ygrex.ru>
---
applies to linux-next

the same value casted the same way few lines below:
	csum = ksocknal_csum(~0, (void *)tx->tx_iov[0].iov_base,

then it seems like a typo in LASSERT() that is got fixed

 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
index 245c9d7..ebd400d 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
@@ -390,7 +390,7 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
 	__u32	csum;
 	void	*base;
 
-	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
+	LASSERT((void *)tx->tx_iov[0].iov_base == &tx->tx_msg);
 	LASSERT(tx->tx_conn != NULL);
 	LASSERT(tx->tx_conn->ksnc_proto == &ksocknal_protocol_v2x);

