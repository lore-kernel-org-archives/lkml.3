Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbaJCXXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:23:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbaJCWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Herbszt <herbszt@gmx.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 147/238] target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE
Date: Fri,  3 Oct 2014 14:31:02 -0700
Message-Id: <20141003212918.383988969@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Herbszt <herbszt@gmx.de>

commit 1f0b030c45c781f9fe568e5e2a813d6c8567a051 upstream.

Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE for setting
the supported ALUA access states via configfs, originally introduced
in commit b0a382c5.

A value of 1 should enable the support, not disable it.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2359,7 +2359,7 @@ static ssize_t target_core_alua_tg_pt_gp
 		pr_err("Invalid value '%ld', must be '0' or '1'\n", tmp); \
 		return -EINVAL;						\
 	}								\
-	if (!tmp)							\
+	if (tmp)							\
 		t->_var |= _bit;					\
 	else								\
 		t->_var &= ~_bit;					\


