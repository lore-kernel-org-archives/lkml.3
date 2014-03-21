Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966782AbaCUAe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:34:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965846AbaCUAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 53/85] iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
Date: Thu, 20 Mar 2014 17:09:56 -0700
Message-Id: <20140321000606.274059353@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit a2a99cea5ec7c1e47825559f0e75a4efbcf8aee3 upstream.

This patch fixes a bug in iscsit_get_tpg_from_np() where the
tpg->tpg_state sanity check was looking for TPG_STATE_FREE,
instead of != TPG_STATE_ACTIVE.

The latter is expected during a normal TPG shutdown once the
tpg_state goes into TPG_STATE_INACTIVE in order to reject any
new incoming login attempts.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_tpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -138,7 +138,7 @@ struct iscsi_portal_group *iscsit_get_tp
 	list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
 
 		spin_lock(&tpg->tpg_state_lock);
-		if (tpg->tpg_state == TPG_STATE_FREE) {
+		if (tpg->tpg_state != TPG_STATE_ACTIVE) {
 			spin_unlock(&tpg->tpg_state_lock);
 			continue;
 		}


