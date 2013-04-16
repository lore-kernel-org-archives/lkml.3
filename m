Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab3DPBhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:37:54 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38998 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab3DPBhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:37:53 -0400
Date: Tue, 16 Apr 2013 09:37:34 +0800
From: Wang YanQing <udknight@gmail.com>
To: mingo@kernel.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86:aperture_64: drop not needed checking
Message-ID: <20130416013734.GA14641@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mingo@kernel.org,
	yinghai@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The memblock_find_in_range return value, addr, will
make sure "addr + aper_size" not beyond GART_MAX_ADDR.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/kernel/aperture_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..fd972a3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -87,7 +87,7 @@ static u32 __init allocate_aperture(void)
 	 */
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
-	if (!addr || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
-- 
1.7.12.4.dirty
