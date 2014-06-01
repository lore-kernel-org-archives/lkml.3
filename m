Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbaFANcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:32:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37500 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaFANcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:39 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rashika Kheria <rashika.kheria@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: pmgr: dspapi.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:33:31 +0200
Message-Id: <1401629611-19166-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b7d5c8c..4e12a5b 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -340,7 +340,7 @@ int api_init_complete2(void)
 u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
 {
 	u8 *pndb_props;
-	u32 num_nodes;
+	u32 num_nodes = 0;
 	int status = 0;
 	u32 size = args->args_mgr_enumnode_info.ndb_props_size;
 
@@ -372,7 +372,7 @@ u32 mgrwrap_enum_node_info(union trapped_args *args, void *pr_ctxt)
 u32 mgrwrap_enum_proc_info(union trapped_args *args, void *pr_ctxt)
 {
 	u8 *processor_info;
-	u8 num_procs;
+	u8 num_procs = 0;
 	int status = 0;
 	u32 size = args->args_mgr_enumproc_info.processor_info_size;
 
@@ -475,7 +475,7 @@ u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
 	int status = 0;
 	struct dsp_notification *anotifications[MAX_EVENTS];
 	struct dsp_notification notifications[MAX_EVENTS];
-	u32 index, i;
+	u32 index = 0, i;
 	u32 count = args->args_mgr_wait.count;
 
 	if (count > MAX_EVENTS)
@@ -1755,7 +1755,7 @@ u32 strmwrap_register_notify(union trapped_args *args, void *pr_ctxt)
  */
 u32 strmwrap_select(union trapped_args *args, void *pr_ctxt)
 {
-	u32 mask;
+	u32 mask = 0;
 	struct strm_object *strm_tab[MAX_STREAMS];
 	int status = 0;
 	struct strm_res_object *strm_res;
-- 
1.7.10.4

