Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3FFLVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:21:31 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51698 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3FFLV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:21:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/4] ARM: ux500: Remove call to u8500_of_init_devices() - again
Date: Thu,  6 Jun 2013 12:21:16 +0100
Message-Id: <1370517676-10909-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow, probably due to a merge error the call to u8500_of_init_devices()
has re-appeared in next, causing this error:

arch/arm/mach-ux500/cpu-db8500.c: In function ‘u8500_init_machine’:
arch/arm/mach-ux500/cpu-db8500.c:268:2: error: implicit declaration of     \
  function ‘u8500_of_init_devices’ [-Werror=implicit-function-declaration]
arch/arm/mach-ux500/cpu-db8500.c:268:9: warning: assignment makes pointer  \
  from integer without a cast [enabled by default]

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index d8ee616..f391d08 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -264,9 +264,6 @@ static void __init u8500_init_machine(void)
 	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
 		/* TODO: Add pinmaps for ccu9540 board. */
 
-	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
-	parent = u8500_of_init_devices();
-
 	/* automatically probe child nodes of dbx5x0 devices */
 	if (of_machine_is_compatible("st-ericsson,u8540"))
 		of_platform_populate(NULL, u8500_local_bus_nodes,
-- 
1.7.10.4

