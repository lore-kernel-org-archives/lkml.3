Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLQWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:40:11 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62624 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaLQWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:40:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srikrishan Malik <srikrishanmalik@gmail.com>,
        Peng Tao <bergwolf@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: mdc: mdc_lib.c:  Removed an unnecessary NULL check
Date: Wed, 17 Dec 2014 23:42:53 +0100
Message-Id: <1418856173-8222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed an unnecessary NULL check.
I have checked the only place this function is called from.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/mdc/mdc_lib.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index e8732cc..a798c2b 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -224,10 +224,9 @@ void mdc_open_pack(struct ptlrpc_request *req, struct md_op_data *op_data,
 	rec->cr_fsuid    = from_kuid(&init_user_ns, current_fsuid());
 	rec->cr_fsgid    = from_kgid(&init_user_ns, current_fsgid());
 	rec->cr_cap      = cfs_curproc_cap_pack();
-	if (op_data != NULL) {
-		rec->cr_fid1 = op_data->op_fid1;
-		rec->cr_fid2 = op_data->op_fid2;
-	}
+	rec->cr_fid1 = op_data->op_fid1;
+	rec->cr_fid2 = op_data->op_fid2;
+
 	rec->cr_mode     = mode;
 	cr_flags = mds_pack_open_flags(flags, mode);
 	rec->cr_rdev     = rdev;
-- 
1.7.10.4

