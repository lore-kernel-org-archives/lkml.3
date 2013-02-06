Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3BFITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:19:54 -0500
Received: from ozlabs.org ([203.10.76.45]:54037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3BFIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:19:26 -0500
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] kvm tools: Return error status in lkvm list
Date: Wed,  6 Feb 2013 19:19:11 +1100
Message-Id: <1360138756-1991-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently list always returns 0, even if there was an error. Instead
have it accumulate any errors and return that.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/builtin-list.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/builtin-list.c b/tools/kvm/builtin-list.c
index 9299f17..c35be93 100644
--- a/tools/kvm/builtin-list.c
+++ b/tools/kvm/builtin-list.c
@@ -123,7 +123,7 @@ static void parse_setup_options(int argc, const char **argv)
 
 int kvm_cmd_list(int argc, const char **argv, const char *prefix)
 {
-	int r;
+	int status, r;
 
 	parse_setup_options(argc, argv);
 
@@ -133,17 +133,23 @@ int kvm_cmd_list(int argc, const char **argv, const char *prefix)
 	printf("%6s %-20s %s\n", "PID", "NAME", "STATE");
 	printf("------------------------------------\n");
 
+	status = 0;
+
 	if (run) {
 		r = kvm_list_running_instances();
 		if (r < 0)
 			perror("Error listing instances");
+
+		status |= r;
 	}
 
 	if (rootfs) {
 		r = kvm_list_rootfs();
 		if (r < 0)
 			perror("Error listing rootfs");
+
+		status |= r;
 	}
 
-	return 0;
+	return status;
 }
-- 
1.7.10.4

