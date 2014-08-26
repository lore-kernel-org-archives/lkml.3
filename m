Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbaHZOLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:11:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38330 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbaHZOKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:50 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-82-53fc956462aa
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 4/5] ARM: dts: exynos4x12: Add utility macro to define pin
 sleep states
Date: Tue, 26 Aug 2014 16:10:27 +0200
Message-id: <1409062228-14690-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xq7opU/8EG3xrtLb4/vAUq8XfScfY
	LR7Nf8xs0bvgKpvFpsfXWC0u75rDZjHj/D4mi9uXeS3WHrnLbnHq+mc2ixvTW1gt1s94zWKx
	atcfRovLjWYOfB4tzT1sHr9/TWL0WPQ9y2PnrLvsHpuX1HtcOdHE6tHb/I7No2/LKkaPo3/Z
	PD5vkgvgiuKySUnNySxLLdK3S+DK6Nl9ga3gCGdF47wFLA2MD9i7GDk5JARMJJpObGKBsMUk
	Ltxbz9bFyMUhJLCUUeLrl0lMEE4fk8TD+4vZQKrYBNQkPjc8ArNFBFQlPrctYAcpYhbYyCzx
	4+8EsLHCAjESGw+fZgKxWYCKju48xApi8wo4SbRPvw+1Tk5i1cZ9YDWcAs4SP59sBasRAqrZ
	+3A16wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQsL46w7GpcesDjEKcDAq8fA+
	SPsdLMSaWFZcmXuIUYKDWUmE90fSn2Ah3pTEyqrUovz4otKc1OJDjEwcnFINjDEH3Xa0rHnt
	Gu+XtjDI783L1qzA2wfXnhG03+8+zSAybvGdsqchSfJniz+8q+JJFBLeapm80P6p2Em+q99P
	9b+1tDTiemNlGn2M3fnU388rudY0PTmskPQipCN80s+Sku6MAKMlAtcMdwZ3SsZ4XRRyzON8
	GjB3S1SL36QA9iqvDKeTjosuK7EUZyQaajEXFScCAM25zvtBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a convenient macro which constructs an Exynos pinctrl
pinconf node containing properties needed to configure sleep state of
given pin with given parameters. It will be used by further patch which
adds a large number of sleep states for pins that need such
configuration on certain boards.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
index 99b26df..927fec6 100644
--- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
@@ -12,6 +12,22 @@
  * published by the Free Software Foundation.
 */
 
+#define PIN_PULL_NONE		0
+#define PIN_PULL_DOWN		1
+#define PIN_PULL_UP		3
+
+#define PIN_PDN_OUT0		0
+#define PIN_PDN_OUT1		1
+#define PIN_PDN_INPUT		2
+#define PIN_PDN_PREV		3
+
+#define PIN_SLP(_pin, _mode, _pull)				\
+	_pin {							\
+		samsung,pins = #_pin;				\
+		samsung,pin-con-pdn = <PIN_PDN_ ##_mode>;	\
+		samsung,pin-pud-pdn = <PIN_PULL_ ##_pull>;	\
+	}
+
 / {
 	pinctrl@11400000 {
 		gpa0: gpa0 {
-- 
2.0.4

