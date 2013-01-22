Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3AVQoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:44:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54424 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab3AVQod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:44:33 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/4] ARM: OMAP2+: clock: DEFINE_STRUCT_CLK_FLAGS helper
Date: Tue, 22 Jan 2013 22:14:23 +0530
Message-ID: <abe7aceb564b97ab00b88b13a9aac487363e01c1.1358871018.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871018.git.afzal@ti.com>
References: <cover.1358871018.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STRUCT_CLK does not have the capability to set flags, define
DEFINE_STRUCT_CLK_FLAGS to handle flags. This is needed to add
SET_RATE_PARENT flag in statically defined lcd clock in am335x.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/clock.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index b402048..60ddd86 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -65,6 +65,17 @@ struct clockdomain;
 		.ops = &_clkops_name,				\
 	};
 
+#define DEFINE_STRUCT_CLK_FLAGS(_name, _parent_array_name,	\
+				_clkops_name, _flags)		\
+	static struct clk _name = {				\
+		.name = #_name,					\
+		.hw = &_name##_hw.hw,				\
+		.parent_names = _parent_array_name,		\
+		.num_parents = ARRAY_SIZE(_parent_array_name),	\
+		.ops = &_clkops_name,				\
+		.flags = _flags,				\
+	};
+
 #define DEFINE_STRUCT_CLK_HW_OMAP(_name, _clkdm_name)		\
 	static struct clk_hw_omap _name##_hw = {		\
 		.hw = {						\
-- 
1.7.12

