Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHIXro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:47:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:57866 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHIXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:47:43 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Liang Zhen <liang.zhen@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Masanari Iida <standby24x7@gmail.com>, Ann Koehler <amk@cray.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: ptlrpc: nrs.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:49:12 +0200
Message-Id: <1407628152-24876-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/ptlrpc/nrs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/nrs.c b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
index 12151aa..a914447 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/nrs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/nrs.c
@@ -1162,6 +1162,7 @@ int ptlrpc_nrs_policy_register(struct ptlrpc_nrs_pol_conf *conf)
 		GOTO(fail, rc = -ENOMEM);
 
 	strncpy(desc->pd_name, conf->nc_name, NRS_POL_NAME_MAX);
+	desc->pd_name[NRS_POL_NAME_MAX - 1] = '\0';
 	desc->pd_ops		 = conf->nc_ops;
 	desc->pd_compat		 = conf->nc_compat;
 	desc->pd_compat_svc_name = conf->nc_compat_svc_name;
-- 
1.7.10.4

