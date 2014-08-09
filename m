Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaHIXqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:46:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46247 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaHIXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:46:31 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Christoph Jaeger <email@christophjaeger.info>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Masanari Iida <standby24x7@gmail.com>, Ann Koehler <amk@cray.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: obdclass: genops.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:48:00 +0200
Message-Id: <1407628080-24789-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/obdclass/genops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index 3210ad8..082b5b9 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -328,6 +328,7 @@ struct obd_device *class_newdev(const char *type_name, const char *name)
 			result->obd_type = type;
 			strncpy(result->obd_name, name,
 				sizeof(result->obd_name) - 1);
+			result->obd_name[sizeof(result->obd_name) - 1] = '\0';
 			obd_devs[i] = result;
 		}
 	}
-- 
1.7.10.4

