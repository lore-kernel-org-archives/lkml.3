Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3KTSWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:22:10 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40422 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3KTSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:21:49 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/3] ARM: EXYNOS: Constify clksrc immutable register restore tables
Date: Thu, 21 Nov 2013 02:21:26 +0800
Message-Id: <1384971686-7208-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clksrc tables are constant, they are not used to store register values
at suspend.

size arch/arm/mach-exynos/pm.o
   text	   data	    bss
   1591	    212	     12	   // Before
   1671	    132	     12	   // After

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 arch/arm/mach-exynos/pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index c679db5..7fb0f13 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -36,7 +36,7 @@
 
 #include "common.h"
 
-static struct sleep_save exynos4_set_clksrc[] = {
+static const struct sleep_save exynos4_set_clksrc[] = {
 	{ .reg = EXYNOS4_CLKSRC_MASK_TOP		, .val = 0x00000001, },
 	{ .reg = EXYNOS4_CLKSRC_MASK_CAM		, .val = 0x11111111, },
 	{ .reg = EXYNOS4_CLKSRC_MASK_TV			, .val = 0x00000111, },
@@ -48,7 +48,7 @@ static struct sleep_save exynos4_set_clksrc[] = {
 	{ .reg = EXYNOS4_CLKSRC_MASK_DMC		, .val = 0x00010000, },
 };
 
-static struct sleep_save exynos4210_set_clksrc[] = {
+static const struct sleep_save exynos4210_set_clksrc[] = {
 	{ .reg = EXYNOS4210_CLKSRC_MASK_LCD1		, .val = 0x00001111, },
 };
 
-- 
1.8.4.1

