Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3GVQMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42769 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab3GVQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:06 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        "Alexander.Boyko" <alexander_boyko@xyratex.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 28/48] staging/lustre/crypto: add crc32c module loading to libcfs
Date: Tue, 23 Jul 2013 00:06:49 +0800
Message-Id: <1374509230-3324-29-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander.Boyko" <alexander_boyko@xyratex.com>

This patch add automatically module loading for crc32c
when libcfs is starting.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2212
Lustre-change: http://review.whamcloud.com/4372
Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Shuichi Ihara <sihara@ddn.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
index 8e35777..b6c79bc 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-crypto.c
@@ -274,6 +274,8 @@ static int adler32;
 
 int cfs_crypto_register(void)
 {
+	request_module("crc32c");
+
 	adler32 = cfs_crypto_adler32_register();
 
 	/* check all algorithms and do performance test */
-- 
1.7.9.5

