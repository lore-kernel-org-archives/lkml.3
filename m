Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaEEK6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:58:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58092 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaEEK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:58:50 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-a1-53676ee8b980
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 1/7] arm: firmware: Check firmware is running or not
Date: Mon, 05 May 2014 12:57:13 +0200
Message-id: <1399287439-31376-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2XeenBBh37mS02zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZa2Ys
	Ziro4ql4dusqUwPjPc4uRk4OCQETiRtNyxkhbDGJC/fWs3UxcnEICSxilJhzbCELhNPFJHHk
	yHV2kCo2ASuJie2rwDpEBNQkehZvZQQpYhbYyyyxtHsTWJGwgItE7825YEUsAqoSz9tnsYLY
	vAIeEp86TrBBrFOU6H42AczmFPCUWLr5MTOILQRUs+FtO9sERt4FjAyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYID85nUDsaVDRaHGAU4GJV4eBOY04OFWBPLiitzDzFKcDArifBmJwKF
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MEr8+XRR4BWT
	tAD7sY1vJql8vr1XND3kgcaPbbJ83p9X954731Jx61v9qdAut6/7LSPOu7yZWXey79BxtfY/
	TToBt0qeF7yRW/nH58e/W6W5nhVivhNm8nilKZbJWdk+efz+PZ9TlPetA4zpTT//v96WOpnn
	/TH73pL2jEmufUbX1xVFHe5e9FqJpTgj0VCLuag4EQDu36U5SAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

To support multi-platform, it needs to know it's running under secure
OS or not.  Sometimes it needs to access physical address by SMC calls.

e.g.,
        if (firmware_run()) {
                addr = physical address;
        } else {
                addr = virtual address;
        }

        call_firmware_ops(read_address, addr, &value);

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/common/firmware.c      | 5 +++++
 arch/arm/include/asm/firmware.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/common/firmware.c b/arch/arm/common/firmware.c
index 27ddccb..e9d9ee5 100644
--- a/arch/arm/common/firmware.c
+++ b/arch/arm/common/firmware.c
@@ -16,3 +16,8 @@
 static const struct firmware_ops default_firmware_ops;
 
 const struct firmware_ops *firmware_ops = &default_firmware_ops;
+
+int firmware_run(void)
+{
+	return firmware_ops != &default_firmware_ops;
+}
diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 2c9f10d..c72ec47 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -46,6 +46,9 @@ struct firmware_ops {
 /* Global pointer for current firmware_ops structure, can't be NULL. */
 extern const struct firmware_ops *firmware_ops;
 
+/* Check firmware is running */
+extern int firmware_run(void);
+
 /*
  * call_firmware_op(op, ...)
  *
-- 
1.8.2.3

