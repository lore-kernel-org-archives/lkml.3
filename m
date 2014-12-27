Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaL0UsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:48:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48678 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaL0Ury (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:47:54 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 1/5] staging: lustre: selftest: fix "not declared" by declaring in header
Date: Sat, 27 Dec 2014 12:46:46 -0800
Message-Id: <1419713210-8198-2-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
References: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several "symbol '...' was not declared" sparse warnings which
are caused by global variables by declaring them in the header file.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/selftest.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/lustre/lnet/selftest/selftest.h b/drivers/staging/lustre/lnet/selftest/selftest.h
index 9b5c5df..d487018 100644
--- a/drivers/staging/lustre/lnet/selftest/selftest.h
+++ b/drivers/staging/lustre/lnet/selftest/selftest.h
@@ -609,4 +609,16 @@ srpc_wait_service_shutdown(srpc_service_t *sv)
 	}
 }
 
+extern sfw_test_client_ops_t brw_test_client;
+void brw_init_test_client(void);
+
+extern srpc_service_t brw_test_service;
+void brw_init_test_service(void);
+
+extern sfw_test_client_ops_t ping_test_client;
+void ping_init_test_client(void);
+
+extern srpc_service_t ping_test_service;
+void ping_init_test_service(void);
+
 #endif /* __SELFTEST_SELFTEST_H__ */
-- 
2.1.4

