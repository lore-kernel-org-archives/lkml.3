Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaD2Gtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:49:49 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39376 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbaD2Gtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:49:47 -0400
X-Google-Original-From: Lad Prabhakar <prabhakar.csengg@gmail.com
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci_vpfe: dm365_resizer: fix sparse warning
Date: Tue, 29 Apr 2014 12:19:34 +0530
Message-Id: <1398754174-6892-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning,
dm365_resizer.c:223:1: warning: symbol 'resizer_calculate_resize_ratios' was not declared. Should it be static?
dm365_resizer.c:313:5: warning: symbol 'resizer_configure_output_win' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 8e13bd4..8828d6c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -219,7 +219,7 @@ configure_resizer_out_params(struct vpfe_resizer_device *resizer, int index,
  * @resizer: Pointer to VPFE resizer subdevice.
  * @index: index RSZ_A-resizer-A RSZ_B-resizer-B.
  */
-void
+static void
 resizer_calculate_resize_ratios(struct vpfe_resizer_device *resizer, int index)
 {
 	struct resizer_params *param = &resizer->config;
@@ -310,7 +310,7 @@ resizer_calculate_sdram_offsets(struct vpfe_resizer_device *resizer, int index)
 	return 0;
 }
 
-int resizer_configure_output_win(struct vpfe_resizer_device *resizer)
+static int resizer_configure_output_win(struct vpfe_resizer_device *resizer)
 {
 	struct resizer_params *param = &resizer->config;
 	struct vpfe_rsz_output_spec output_specs;
-- 
1.7.9.5

