Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaJGPxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:53:33 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:33326 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaJGPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:53:31 -0400
Message-ID: <54340C70.9070505@gmail.com>
Date: Tue, 07 Oct 2014 17:53:20 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v3 1/2] staging: gs_fpgaboot: Use print_hex_dump_bytes instead
 of pr_info
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com>	 <54340568.7090700@gmail.com> <1412695842.2916.49.camel@joe-AO725>
In-Reply-To: <1412695842.2916.49.camel@joe-AO725>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Use print_hex_dump_bytes instead of pr_info

Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
Reviewed-by: Insop Song <insop.song@gainspeed.com>

---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 6aa9d7c..9764a9a 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -46,27 +46,6 @@ static char	*file = "xlinx_fpga_firmware.bit";
 module_param(file, charp, S_IRUGO);
 MODULE_PARM_DESC(file, "Xilinx FPGA firmware file.");
 
-#ifdef DEBUG_FPGA
-static void datadump(char *msg, void *m, int n)
-{
-	int i;
-	unsigned char *c;
-
-	pr_info("=== %s ===\n", msg);
-
-	c = m;
-
-	for (i = 0; i < n; i++) {
-		if ((i&0xf) == 0)
-			pr_info(KERN_INFO "\n  0x%4x: ", i);
-
-		pr_info("%02X ", c[i]);
-	}
-
-	pr_info("\n");
-}
-#endif /* DEBUG_FPGA */
-
 static void read_bitstream(char *bitdata, char *buf, int *offset, int rdsize)
 {
 	memcpy(buf, bitdata + *offset, rdsize);
@@ -220,9 +199,9 @@ static int gs_download_image(struct fpgaimage *fimage, enum wbus bus_bytes)
 	size = fimage->lendata;
 
 #ifdef DEBUG_FPGA
-	datadump("bitfile sample", bitdata, 0x100);
+	print_hex_dump_bytes("bitfile sample: ", DUMP_PREFIX_OFFSET,
+			     bitdata, 0x100);
 #endif /* DEBUG_FPGA */
-
 	if (!xl_supported_prog_bus_width(bus_bytes)) {
 		pr_err("unsupported program bus width %d\n",
 				bus_bytes);
-- 
2.1.2

