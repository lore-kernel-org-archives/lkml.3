Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760Ab3DCHNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:13:17 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:46161 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762662Ab3DCHNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:13:16 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kbuild@vger.kernel.org>
Subject: [PATCH] Kbuild: Avoid DTB rebuilds if source files are untouched
Date: Wed, 3 Apr 2013 12:42:21 +0530
Message-ID: <1364973141-16354-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, for every ARC kernel build I see the following:

--------------->8-----------------
  DTB    arch/arc/boot/dts/angel4.dtb.S
  AS      arch/arc/boot/dts/angel4.dtb.o
  LD      arch/arc/boot/dts/built-in.o
rm arch/arc/boot/dts/angel4.dtb.S        <-- forces rebuild next iter
  CHK     kernel/config_data.h
--------------->8-----------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 scripts/Makefile.lib |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 07125e6..17f96f4 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -265,6 +265,8 @@ cmd_dt_S_dtb=						\
 	echo '.balign STRUCT_ALIGNMENT'; 		\
 ) > $@
 
+.PRECIOUS: $(obj)/%.dtb.S
+
 $(obj)/%.dtb.S: $(obj)/%.dtb
 	$(call cmd,dt_S_dtb)
 
-- 
1.7.10.4

