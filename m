Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbbAAQUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:20:17 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:51434 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbAAQUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:20:15 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Insop Song <insop.song@gainspeed.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Bartoszkiewicz?= 
	<mbartoszkiewicz@gmail.com>,
        Rocco Folino <lordzen87@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gs_fpgaboot: io.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:23:13 +0100
Message-Id: <1420129393-29038-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function bitswap() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/gs_fpgaboot/io.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/io.c b/drivers/staging/gs_fpgaboot/io.c
index b260e45..819db53 100644
--- a/drivers/staging/gs_fpgaboot/io.c
+++ b/drivers/staging/gs_fpgaboot/io.c
@@ -79,15 +79,6 @@ void xl_shift_bytes_out(enum wbus bus_byte, unsigned char *pdata)
 /*
  * generic bit swap for xilinx SYSTEMMAP FPGA programming
  */
-static inline unsigned char bitswap(unsigned char s)
-{
-	unsigned char d;
-
-	d = (((s&0x80)>>7) | ((s&0x40)>>5) | ((s&0x20)>>3) | ((s&0x10)>>1) |
-		((s&0x08)<<1) | ((s&0x04)<<3) | ((s&0x02)<<5) | ((s&0x01)<<7));
-	return d;
-}
-
 void xl_program_b(int32_t i)
 {
 }
-- 
1.7.10.4

