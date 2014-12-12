Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbaLLUKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:10:02 -0500
Received: from smtp-3.sys.kth.se ([130.237.48.192]:60850 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297AbaLLUJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:09:56 -0500
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linus.walleij@linaro.org
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCH 1/4] sh-pfc: add macro to define pinmux without function
Date: Fri, 12 Dec 2014 21:01:34 +0100
Message-Id: <1418414497-23741-2-git-send-email-niso@kth.se>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418414497-23741-1-git-send-email-niso@kth.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used to define pinmux configurations where the pinmux function have no
representation in the configuration registers but instead solely depends
on a group selection.

Signed-off-by: Niklas Söderlund <niso@kth.se>
---
 drivers/pinctrl/sh-pfc/sh_pfc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/sh_pfc.h b/drivers/pinctrl/sh-pfc/sh_pfc.h
index 5b72831..c837286 100644
--- a/drivers/pinctrl/sh-pfc/sh_pfc.h
+++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
@@ -167,6 +167,8 @@ struct sh_pfc_soc_info {
 	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ipsr)
 #define PINMUX_IPSR_NOGM(ispr, fn, ms)					\
 	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ms)
+#define PINMUX_IPSR_NOFN(ipsr, fn, ms)					\
+	PINMUX_DATA(fn##_MARK, FN_##ipsr, FN_##ms)
 #define PINMUX_IPSR_MSEL(ipsr, fn, ms)					\
 	PINMUX_DATA(fn##_MARK, FN_##fn, FN_##ipsr, FN_##ms)
 #define PINMUX_IPSR_MODSEL_DATA(ipsr, fn, ms)				\
-- 
2.1.3

