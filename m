Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaGZOeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:34:03 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48572 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaGZOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:34:01 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] s390: net: qeth_core_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:35:26 +0200
Message-Id: <1406385326-3289-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/net/qeth_core_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f54bec5..ec9b4d7 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5275,7 +5275,7 @@ static int qeth_add_dbf_entry(struct qeth_card *card, char *name)
 	new_entry = kzalloc(sizeof(struct qeth_dbf_entry), GFP_KERNEL);
 	if (!new_entry)
 		goto err_dbg;
-	strncpy(new_entry->dbf_name, name, DBF_NAME_LEN);
+	strlcpy(new_entry->dbf_name, name, DBF_NAME_LEN);
 	new_entry->dbf_info = card->debug;
 	mutex_lock(&qeth_dbf_list_mutex);
 	list_add(&new_entry->dbf_list, &qeth_dbf_list);
-- 
1.7.10.4

