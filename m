Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3CLWdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3CLWco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asias He <asias@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 015/100] target/pscsi: Fix page increment
Date: Tue, 12 Mar 2013 15:31:00 -0700
Message-Id: <20130312223124.628131873@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.

The page++ is wrong. It makes bio_add_pc_page() pointing to a wrong page
address if the 'while (len > 0 && data_len > 0) { ... }' loop is
executed more than one once.

Signed-off-by: Asias He <asias@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pscsi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -940,7 +940,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct
 				bio = NULL;
 			}
 
-			page++;
 			len -= bytes;
 			data_len -= bytes;
 			off = 0;


