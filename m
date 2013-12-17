Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LQChH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:37:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62032 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LQChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:37:04 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 17 Dec 2013 11:37:55 +0900
Message-Id: <20131217023755.24573.96747.sendpatchset@w520>
In-Reply-To: <20131217023745.24573.3660.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520>
Subject: [PATCH 01/05 v2] pinctrl: sh-pfc: Rework _GP_GPIO, introduce _GP_GPIO32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Rework _GP_GPIO to take banksize as argument, introduce
_GP_GPIO32 for SoCs with 32-bit GPIO banks.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Developed on top of renesas git tag renesas-devel-v3.13-rc3-20131214v2

 drivers/pinctrl/sh-pfc/sh_pfc.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- 0001/drivers/pinctrl/sh-pfc/sh_pfc.h
+++ work/drivers/pinctrl/sh-pfc/sh_pfc.h	2013-12-16 19:35:12.000000000 +0900
@@ -214,13 +214,14 @@ struct sh_pfc_soc_info {
 #define GP_ALL(str)			CPU_ALL_PORT(_GP_ALL, str)
 
 /* PINMUX_GPIO_GP_ALL - Expand to a list of sh_pfc_pin entries */
-#define _GP_GPIO(bank, _pin, _name, sfx)				\
-	[(bank * 32) + _pin] = {					\
-		.pin = (bank * 32) + _pin,				\
+#define _GP_GPIO(banksize, bank, _pin, _name, sfx)			\
+	[(bank * banksize) + _pin] = {					\
+		.pin = (bank * banksize) + _pin,			\
 		.name = __stringify(_name),				\
 		.enum_id = _name##_DATA,				\
 	}
-#define PINMUX_GPIO_GP_ALL()		CPU_ALL_PORT(_GP_GPIO, unused)
+#define _GP_GPIO32(bank, _pin, _name, sfx) _GP_GPIO(32, bank, _pin, _name, sfx)
+#define PINMUX_GPIO_GP_ALL()		CPU_ALL_PORT(_GP_GPIO32, unused)
 
 /* PINMUX_DATA_GP_ALL -  Expand to a list of name_DATA, name_FN marks */
 #define _GP_DATA(bank, pin, name, sfx)	PINMUX_DATA(name##_DATA, name##_FN)
