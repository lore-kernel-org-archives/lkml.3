Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3KHGq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:46:28 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64064 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3KHGqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:46:23 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] ARM: davinci: Fix number of resources passed to davinci_gpio_register() call
Date: Fri,  8 Nov 2013 12:15:56 +0530
Message-Id: <1383893156-28010-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The davinci_gpio_register() function expects the number of
resources as the second parameter, but size of resources
was passed to it due to which it was causing unexpected
behaviour. This patch fixes the same by passing the
ARRAY_SIZE of resources.

Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/dm355.c  |    2 +-
 arch/arm/mach-davinci/dm365.c  |    2 +-
 arch/arm/mach-davinci/dm644x.c |    2 +-
 arch/arm/mach-davinci/dm646x.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index ef9ff1f..536ce52 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -906,7 +906,7 @@ static struct davinci_gpio_platform_data dm355_gpio_platform_data = {
 int __init dm355_gpio_register(void)
 {
 	return davinci_gpio_register(dm355_gpio_resources,
-				     sizeof(dm355_gpio_resources),
+				     ARRAY_SIZE(dm355_gpio_resources),
 				     &dm355_gpio_platform_data);
 }
 /*----------------------------------------------------------------------*/
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 1511a06..9c96520 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -720,7 +720,7 @@ static struct davinci_gpio_platform_data dm365_gpio_platform_data = {
 int __init dm365_gpio_register(void)
 {
 	return davinci_gpio_register(dm365_gpio_resources,
-				     sizeof(dm365_gpio_resources),
+				     ARRAY_SIZE(dm365_gpio_resources),
 				     &dm365_gpio_platform_data);
 }
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 143a321..72a3aa7 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -792,7 +792,7 @@ static struct davinci_gpio_platform_data dm644_gpio_platform_data = {
 int __init dm644x_gpio_register(void)
 {
 	return davinci_gpio_register(dm644_gpio_resources,
-				     sizeof(dm644_gpio_resources),
+				     ARRAY_SIZE(dm644_gpio_resources),
 				     &dm644_gpio_platform_data);
 }
 /*----------------------------------------------------------------------*/
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 2a73f29..d1b646c 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -769,7 +769,7 @@ static struct davinci_gpio_platform_data dm646x_gpio_platform_data = {
 int __init dm646x_gpio_register(void)
 {
 	return davinci_gpio_register(dm646x_gpio_resources,
-				     sizeof(dm646x_gpio_resources),
+				     ARRAY_SIZE(dm646x_gpio_resources),
 				     &dm646x_gpio_platform_data);
 }
 /*----------------------------------------------------------------------*/
-- 
1.7.9.5

