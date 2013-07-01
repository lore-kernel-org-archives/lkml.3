Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3GAO4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:56:25 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57151 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3GAO4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:56:24 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dove: fix missing __init section of dove_mpp_gpio_mode
Date: Mon,  1 Jul 2013 16:56:12 +0200
Message-Id: <1372690572-2184-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy dove_mpp_gpio_mode calls orion_gpio_set_valid which is in
__init section. Offending function is not, so this causes a section
mismatch. To fix the mismatch, also move dove_mpp_gpio_mode to
__init section.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/mpp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-dove/mpp.c b/arch/arm/mach-dove/mpp.c
index 60bd729..8a433a5 100644
--- a/arch/arm/mach-dove/mpp.c
+++ b/arch/arm/mach-dove/mpp.c
@@ -47,7 +47,7 @@ static const struct dove_mpp_grp dove_mpp_grp[] = {
 
 /* Enable gpio for a range of pins. mode should be a combination of
    GPIO_OUTPUT_OK | GPIO_INPUT_OK */
-static void dove_mpp_gpio_mode(int start, int end, int gpio_mode)
+static void __init dove_mpp_gpio_mode(int start, int end, int gpio_mode)
 {
 	int i;
 
-- 
1.7.2.5

