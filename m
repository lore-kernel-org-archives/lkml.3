Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3LQCha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:37:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41170 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3LQChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:37:23 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 17 Dec 2013 11:38:14 +0900
Message-Id: <20131217023814.24573.91649.sendpatchset@w520>
In-Reply-To: <20131217023745.24573.3660.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520>
Subject: [PATCH 03/05 v2] pinctrl: sh-pfc: r7s72100 single pin macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Introduce macros that allow description of one pin per line.
Compared to the other ways of doing this, using this style
we can compresses the description of each pin from 9 to 1 line.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 This patch uses RZ_PMX_GROUP and RZ_GROUPS, thanks Laurent!

 drivers/pinctrl/sh-pfc/pfc-r7s72100.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- 0003/drivers/pinctrl/sh-pfc/pfc-r7s72100.c
+++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-12-16 19:14:30.000000000 +0900
@@ -98,9 +98,30 @@ static struct sh_pfc_pin pinmux_pins[] =
 
 #define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))
 
+#define __RZ_STR(pfx, hw, bank, pin, sfx)		\
+	pfx##_##hw##_p##bank##_##pin####sfx
+
+#define RZ_PIN_AND_MUX(pfx, hw, bank, pin, fn)				\
+static const unsigned int __RZ_STR(pfx, hw, bank, pin, _pins)[] = {	\
+	RZ_PORT_PIN(bank, pin),						\
+};									\
+static const unsigned int __RZ_STR(pfx, hw, bank, pin, _mux)[] = {	\
+	P_##bank##_##pin##_MARK_FN##fn,					\
+};
+
+#define RZ_PMX_GROUP(pfx, hw, bank, pin, fn) \
+	SH_PFC_PIN_GROUP(pfx##_##hw##_p##bank##_##pin),
+
+#define __RZ_GROUPS(x) #x
+
+#define RZ_GROUPS(pfx, hw, bank, pin, fn) \
+	__RZ_GROUPS(pfx##_##hw##_p##bank##_##pin),
+
 static const struct sh_pfc_pin_group pinmux_groups[] = {
 };
 
+static const char * const scif2_groups[] = {
+};
 static const struct sh_pfc_function pinmux_functions[] = {
 };
 
