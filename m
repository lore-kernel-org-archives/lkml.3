Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3IPRFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:05:04 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:51410 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3IPRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:05:02 -0400
From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] X.509: remove possible code fragility: enumeration values not handled
Date: Mon, 16 Sep 2013 11:04:54 -0300
Message-Id: <1379340294-13562-1-git-send-email-antonio.alecrim@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 scripts/asn1_compiler.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index db0e5cd..91c4117 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -1353,6 +1353,8 @@ static void render_out_of_line_list(FILE *out)
 			render_opcode(out, "ASN1_OP_END_SET_OF%s,\n", act);
 			render_opcode(out, "_jump_target(%u),\n", entry);
 			break;
+		default:
+			break;
 		}
 		if (e->action)
 			render_opcode(out, "_action(ACT_%s),\n",
-- 
1.8.3.1

