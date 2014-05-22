Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaEVV7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:59:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35887 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaEVV7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:59:19 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: cris: arch-v32: drivers: axisflashmap.c:  Cleaning up inconsistent NULL checks
Date: Fri, 23 May 2014 00:00:09 +0200
Message-Id: <1400796009-12716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up inconsistent NULL checks.
There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/cris/arch-v32/drivers/axisflashmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/drivers/axisflashmap.c b/arch/cris/arch-v32/drivers/axisflashmap.c
index 28dd771..e359cd7 100644
--- a/arch/cris/arch-v32/drivers/axisflashmap.c
+++ b/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -487,7 +487,7 @@ static int __init init_axis_flash(void)
 
 			axis_partitions[pidx].offset = offset + ptable->offset;
 #ifdef CONFIG_ETRAX_NANDFLASH
-			if (main_mtd->type == MTD_NANDFLASH) {
+			if (main_mtd && main_mtd->type == MTD_NANDFLASH) {
 				axis_partitions[pidx].size =
 					(((ptable+1)->offset ==
 					  PARTITIONTABLE_END_MARKER) ?
-- 
1.7.10.4

