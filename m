Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaHTNnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:43:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25486 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaHTNm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:58 -0400
X-AuditID: cbfee61b-f79f86d00000144c-03-53f4a5e0f928
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH/RFC v5 1/2] of: add of_node_ncmp wrapper
Date: Wed, 20 Aug 2014 15:42:42 +0200
Message-id: <1408542163-32764-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQd0HS78EG5xeZGyxccZ6VosPTa3M
	FvOPnGO1OPBnB6NF79XnjBZnm96wW1zeNYfNYuubdYwWPRu2slo8+XiaxYHLo+dNC6vHnWt7
	2Dz+dk1h9ujbsorR4/MmuQDWKC6blNSczLLUIn27BK6M02sXMhXc5a54vn4HWwPje84uRk4O
	CQETiY7Lx9khbDGJC/fWs3UxcnEICUxnlJjesZsVwmlnknjwvpENpIpNwFDi54vXTCC2iEC5
	RM/7Z2AdzAIvGCV2Nq9jBEkIC1hI7Pu3jRXEZhFQlVi1fS4ziM0r4CFxaeUSIJsDaJ2CxJxJ
	NiAmp4CnxLcNtSAVQkAV+z/8Zp/AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDI
	PZPewbiqweIQowAHoxIP741FX4KFWBPLiitzDzFKcDArifC2dwKFeFMSK6tSi/Lji0pzUosP
	MUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MHJ+FnV6yVavPy+c8ei/lSLPF2fkM/xj
	T3i0krtixebEVu/j356VlLxujXt/8pXp1M3Gixkaz0Z8M53yvLbC4sm0w6d9n3CJTxD0NV17
	s7cy/nN7xlVBiW3+r62thZle825Xbp92fmOE9HpB4dU/fLbEW29TuNMhfv6a7kGLlVM5/YVq
	t/Asn6bEUpyRaKjFXFScCABoTa7eNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrapper for strnicmp is required for checking whether a node has
expected prefix.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/sparc/include/asm/prom.h |    1 +
 include/linux/of.h            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index d955c8d..272f87a 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -30,6 +30,7 @@
 #define of_compat_cmp(s1, s2, l)	strncmp((s1), (s2), (l))
 #define of_prop_cmp(s1, s2)		strcasecmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcmp((s1), (s2))
+#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
 
 struct of_irq_controller {
 	unsigned int	(*irq_build)(struct device_node *, unsigned int, void *);
diff --git a/include/linux/of.h b/include/linux/of.h
index 6c4363b..b1e11ba 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -197,6 +197,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
 #define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
 #define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+#define of_node_ncmp(s1, s2, n)		strnicmp((s1), (s2), (n))
 #endif
 
 /* flag descriptions */
-- 
1.7.9.5

