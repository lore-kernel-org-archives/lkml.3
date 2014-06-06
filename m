Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaFFRfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:35:00 -0400
Received: from mout.web.de ([212.227.15.14]:58620 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaFFRe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:58 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 11/13] iscsi-target: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:30 +0200
Message-Id: <1402076072-4044-11-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:OB3bJuHR2+zBtW1HxH7smzo0fploB1/pUBmZ3BSpg4S3ASqEhnb
 lv5R3IILdBeugAwezT6dHGrXeCorhZI2tQZ4rRuMI/xwsz9+XB1RXUQC6spTvfdhncwHWcw
 ZeFoBrUgqqGxDFHSizygrYKYYPxmqfDmwIbL9u+l9nWBdQOy/Cv9gLYIkU+o8A2CwLY5FUi
 4BkmwCikGr0qhlqAoIxaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target_erl1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index cda4d80..1926d0b 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -835,8 +835,8 @@ static int iscsit_attach_ooo_cmdsn(
 					continue;
 
 				/* Insert before this entry */
-				list_add(&ooo_cmdsn->ooo_list,
-					ooo_tmp->ooo_list.prev);
+				list_add_before(&ooo_cmdsn->ooo_list,
+						&ooo_tmp->ooo_list);
 				break;
 			}
 		}
-- 
2.0.0

