Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab3DOIHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:07:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOIHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:07:36 -0400
Date: Mon, 15 Apr 2013 16:07:20 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86:aperture_64: code pattern clean
Message-ID: <20130415080720.GB1994@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, yinghai@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch don't change code function,
it just do prepare for import the
memblock_alloc_in_range to do the code pattern
which looks like below in one function:

memblock_find_in_range()
follow by
memblock_reserve()

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/kernel/aperture_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..1523e75 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -85,9 +85,9 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
+	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR - aper_size,
 				      aper_size, aper_size);
-	if (!addr || addr + aper_size > GART_MAX_ADDR) {
+	if (!addr) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
-- 
1.7.12.4.dirty
