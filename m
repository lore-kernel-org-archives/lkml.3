Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaFBMgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:36:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44542 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbaFBMgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:36:00 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-28-538c6fae5fc9
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
Subject: [PATCH v2 1/7] arm: firmware: Check firmware is running or not
Date: Mon, 02 Jun 2014 14:35:37 +0200
Message-id: <1401712543-14281-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd31+T3BBu9usllsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgy1sxY
	zFTQxVPx7NZVpgbGe5xdjJwcEgImEm+fzWWEsMUkLtxbz9bFyMUhJDCdUWLlxLcsEE4Xk8S6
	TQ/ZQKrYBKwkJravAusQEVCT6Fm8lRGkiFlgL7PE0u5N7CAJYQF3iRmbH4E1sAioSiy9cxus
	gVfAQ+LXlzOsEOsUJbqfTQCr4RTwlFh57yFYXAioZt+rXUwTGHkXMDKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAgOzGdSOxhXNlgcYhTgYFTi4f2p3hMsxJpYVlyZe4hRgoNZSYR3qQVQ
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2NscmVIbfbk
	ZX73NwkXv7xrk+N3c8fuGXuYshrO3tyxIuSPR3Gas4h+9cyFhdPiJsXsE58vf/ksx1/35VGl
	z5vOzkzO3TrtNc+TpFsHFA6zqckZOnJwlLvPvxI37ze74AS7pvdryuRvbnrfsd5jAuOOIw9S
	0/wmbTX4Yy/hknkg7nCRwKvZvUpKLMUZiYZazEXFiQCYqGpXSAIAAA==
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

