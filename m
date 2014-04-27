Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaD0RIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:24 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48069 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbaD0RIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:18 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 28/47] staging/lustre/ldlm: fix NULL pointer dereference
Date: Sun, 27 Apr 2014 13:06:52 -0400
Message-Id: <1398618431-29757-29-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Pointer '*exp' returned from call to function 'class_conn2export'
at line 523 may be NULL and may be dereferenced at line 543.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9323
ntel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 1a8c0d7..42f5f1e 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -514,7 +514,7 @@ int client_connect_import(const struct lu_env *env,
 		LASSERT (imp->imp_state == LUSTRE_IMP_DISCON);
 		GOTO(out_ldlm, rc);
 	}
-	LASSERT((*exp)->exp_connection);
+	LASSERT(*exp != NULL && (*exp)->exp_connection);
 
 	if (data) {
 		LASSERTF((ocd->ocd_connect_flags & data->ocd_connect_flags) ==
-- 
1.8.5.3

