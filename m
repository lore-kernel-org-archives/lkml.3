Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaKMFo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 00:44:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaKMFo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 00:44:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-43-546445397c5b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, nico@linaro.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] ARM: b.L: fix unmet dependency for CPU_PM
Date: Thu, 13 Nov 2014 11:08:18 +0530
Message-id: <1415857098-16928-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWyRsSkStfSNSXE4MgtUYtNj6+xWlzeNYfN
	4vZlXovpx/6yWSza+oXdgdWjpbmHzePOtT1sHpuX1Hv0bVnF6PF5k1wAaxSXTUpqTmZZapG+
	XQJXxuInD9gKVrFXTNsh3cD4m7WLkYNDQsBEYtMcvi5GTiBTTOLCvfVsXYxcHEICSxklLq9a
	xwKRMJF492IaO0RiOqPEin2bWCGcCUwSR18dYwSpYhPQlXjyfi4ziC0i4CZxo7GDCcRmFgiT
	mLD9FjvINmEBK4nj0xVAwiwCqhI/poMcwcnBK+Ah8b2pnQXiIAWJOZNsQMZLCLxmk/hzbw8r
	RL2AxLfJh6BqZCU2HWCGuE1S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/d
	xAgMzNP/nvXtYLx5wPoQowAHoxIP70uWlBAh1sSy4srcQ4ymQBsmMkuJJucDwz+vJN7Q2MzI
	wtTE1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGgMbuBUGSs308X1j+
	Y754RypU8HXP2UViK8qmsp+dFF6wN3RZEP/6yVNi//cfqjDKfeueIPk1aOcfId2j4mGi59dd
	vjnJqyBJMttp6bTGMouEUKMJH9+f/7iAW7No+5a9tssMCxWFlMyf9TGsq3uXvIuJmZF7h9X3
	1jMLY577zL6wMLCgJuK9EktxRqKhFnNRcSIAY7u4b0cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jQV1L15QQg68XeS02Pb7GanF51xw2
	i9uXeS2mH/vLZrFo6xd2B1aPluYeNo871/aweWxeUu/Rt2UVo8fnTXIBrFENjDYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmLnzxgK1jFXjFth3QD42/WLkZODgkBE4l3L6ax
	Q9hiEhfurWfrYuTiEBKYziixYt8mVghnApPE0VfHGEGq2AR0JZ68n8sMYosIuEncaOxgArGZ
	BcIkJmy/BTSJg0NYwEri+HQFkDCLgKrEj+kQy3gFPCS+N7WzgJRICChIzJlkM4GRewEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4MB/JrWDcWWDxSFGAQ5GJR7eFywpIUKsiWXFlbmH
	GCU4mJVEeJt0gEK8KYmVValF+fFFpTmpxYcYTYGWT2SWEk3OB0ZlXkm8obGJuamxqaWJhYmZ
	pZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGRuaJgY0P07h71zOk35y7YUIEg9akv0fTS/5V
	8XVGL38T+raxWswnNndDZFZtcN72mA1n94fGOKbWaUv2HtT0cNQLzbORvZbX2bi/0q3o/aLT
	BYXHF17es/h4cNLNDDHRXdzrrjXeq85YvjlvcauV7J8/gkatm1cUiP/fE+S6sHzndRsN535F
	JZbijERDLeai4kQAOfr08ZICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
we are getting following config warning.

warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
dependencies (SUSPEND || CPU_IDLE)

So BL_SWITCHER should enable CPU_PM only if either of SUSPEND or
CPU_IDLE is selected.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9d580d0..fe3d969 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1417,7 +1417,7 @@ config BL_SWITCHER
 	bool "big.LITTLE switcher support"
 	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU
 	select ARM_CPU_SUSPEND
-	select CPU_PM
+	select CPU_PM if (SUSPEND || CPU_IDLE)
 	help
 	  The big.LITTLE "switcher" provides the core functionality to
 	  transparently handle transition between a cluster of A15's
-- 
1.7.9.5

