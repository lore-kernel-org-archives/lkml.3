Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbbAIPYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26711 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbbAIPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:05 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-54-54aff292b2f7
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Date: Fri, 09 Jan 2015 16:22:57 +0100
Message-id: <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jQd3Jn9aHGNx/xWyxccZ6VoujOycy
	WVz/8pzVYv6Rc6wWvVefM1qcbXrDbnH/61FGi8u75rBZbH2zjtGiZ8NWVou7p46yWeze9ZTV
	4vCbdlaLM/tXsjnweeycdZfd4/DXhSwed67tYfPYM/8Hq0ffllWMHitWf2f3+LxJLoA9issm
	JTUnsyy1SN8ugSvj0+mtzAU7OCp2PD3O1MDYz97FyMkhIWAisXX9HxYIW0ziwr31bF2MXBxC
	AtMZJbb0NLBCOO1MEs2/5jOBVLEJGEr8fPEayObgEBGIlrh0rB4kzCywiUli11ddEFtYIF5i
	9aedrCA2i4CqxLnG+ywg5bwC7hLNH3JATAkBBYk5k2xATE4BD4mW304gphBQwZurhhMYeRcw
	MqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7TZ9I7GFc1WBxiFOBgVOLh3SC3PkSINbGs
	uDL3EKMEB7OSCG/DZqAQb0piZVVqUX58UWlOavEhRmkOFiVxXiX7thAhgfTEktTs1NSC1CKY
	LBMHp1QDI4NtrJBpncaG3LJqo1O1Sx+GVVyXjZ8T4Zu+aMdD7ceGexP+3FNZp7Nrk+38+y4T
	XuUfn1Uk4KGaEfCh7NBWy3v7t7F2avtvsmIK3fjnXOKEc12tr4//m3zu1H75ImEGPsH2Dy1h
	9/9mXBdJSP6cwlIRL3BvCo/kT8PQ828KqzYdXyrcmevrp8RSnJFoqMVcVJwIAKYCpGdPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
from leds-max77693 driver.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693-private.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 08dae01..01799a9 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -113,8 +113,8 @@ enum max77693_pmic_reg {
 #define FLASH_EN_FLASH		0x1
 #define FLASH_EN_TORCH		0x2
 #define FLASH_EN_ON		0x3
-#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
-#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
+#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
+#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
 
 /* MAX77693 MAX_FLASH1 register */
 #define MAX_FLASH1_MAX_FL_EN	0x80
-- 
1.7.9.5

