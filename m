Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaA1CS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:18:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46308 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaA1CS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:18:56 -0500
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [V0 PATCH] pvh: Disable PSE feature for now
Date: Mon, 27 Jan 2014 18:18:39 -0800
Message-Id: <1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
References: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, xen did not expose PSE to pvh guest, but a patch was submitted
to xen list to enable bunch of features for a pvh guest. PSE has not been
looked into for PVH, so until we can do that and test it to make sure it
works, disable the feature to avoid flood of bugs.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/enlighten.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a4d7b64..4e952046 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1497,6 +1497,11 @@ static void __init xen_pvh_early_guest_init(void)
 	xen_have_vector_callback = 1;
 	xen_pvh_set_cr_flags(0);
 
+        /* pvh guests are not quite ready for large pages yet */
+        setup_clear_cpu_cap(X86_FEATURE_PSE);
+        setup_clear_cpu_cap(X86_FEATURE_PSE36);
+
+
 #ifdef CONFIG_X86_32
 	BUG(); /* PVH: Implement proper support. */
 #endif
-- 
1.7.2.3

