Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3B0AyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:54:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3BZX6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Olof Johansson <olof@lixom.net>
Subject: [ 106/150] ARM: integrator: ensure ap_syscon_base is initialised when !CONFIG_MMU
Date: Tue, 26 Feb 2013 15:56:03 -0800
Message-Id: <20130226235535.122099113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ab2a724a2ef9cee5957692257a5d1f08fd7acbbd upstream.

When running on Integrator/AP using atags, ap_syscon_base is initialised
in ->map_io, which isn't called for !MMU platforms.

Instead, initialise the pointer in ->machine_init, as we do when booting
with device-tree.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-integrator/integrator_ap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -613,7 +613,6 @@ static struct map_desc ap_io_desc_atag[]
 static void __init ap_map_io_atag(void)
 {
 	iotable_init(ap_io_desc_atag, ARRAY_SIZE(ap_io_desc_atag));
-	ap_syscon_base = __io_address(INTEGRATOR_SC_BASE);
 	ap_map_io();
 }
 
@@ -685,6 +684,7 @@ static void __init ap_init(void)
 
 	platform_device_register(&cfi_flash_device);
 
+	ap_syscon_base = __io_address(INTEGRATOR_SC_BASE);
 	sc_dec = readl(ap_syscon_base + INTEGRATOR_SC_DEC_OFFSET);
 	for (i = 0; i < 4; i++) {
 		struct lm_device *lmdev;


