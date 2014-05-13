Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaEMPuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:50:07 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53806 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaEMPt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:49:57 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 10/9] dt: deps: fix bug not registering late drivers when OF_DEPENDENCIES is disabled
Date: Tue, 13 May 2014 17:40:34 +0200
Message-Id: <1399995634-5401-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject says all. Patch 5/9 has a bug which avoids registering late drivers
if OF_DEPENDENCIES is disabled.

This also explains the large differences in boot times I've experienced when
comparing boot times with and without DT dependency based initialization order.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>

---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 7591cd1..e16e2b4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -799,9 +799,9 @@ static void __init do_basic_setup(void)
 	of_init_set_recording(false);
 	/* probe available platform drivers with deterministic order */
 	of_init_register_drivers();
+#endif
 	/* register late drivers */
 	do_initcall_level(ARRAY_SIZE(initcall_levels) - 3);
-#endif
 	random_int_secret_init();
 }
 
-- 
1.8.3.1

