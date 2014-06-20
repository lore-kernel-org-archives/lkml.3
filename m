Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966079AbaFTTnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:43:41 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39073 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaFTTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:42:53 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 2/4] thunderbolt: Fix header declaration of tb_find_cap
Date: Fri, 20 Jun 2014 21:42:23 +0200
Message-Id: <1403293345-20772-2-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
References: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tb_find_cap in cap.c takes an enum tb_cap and not an u32. Fix the
declaration in tb.h.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/tb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 18ade5e..8b0d7cf 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -233,7 +233,7 @@ int tb_wait_for_port(struct tb_port *port, bool wait_if_unplugged);
 int tb_port_add_nfc_credits(struct tb_port *port, int credits);
 int tb_port_clear_counter(struct tb_port *port, int counter);
 
-int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, u32 value);
+int tb_find_cap(struct tb_port *port, enum tb_cfg_space space, enum tb_cap cap);
 
 struct tb_path *tb_path_alloc(struct tb *tb, int num_hops);
 void tb_path_free(struct tb_path *path);
-- 
2.0.0

