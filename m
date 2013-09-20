Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3ITUbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:31:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rusk <mark.rusk@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/93] drivers/misc/hpilo: Correct panic when an AUX iLO is detected
Date: Fri, 20 Sep 2013 13:08:09 -0700
Message-Id: <1379707768-1804-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rusk <Mark.Rusk@hp.com>

commit eefbc594abbb1b7e6e7eeadb65ae7c7538474210 upstream.

 Using an uninitialized variable 'devnum' after 'goto out;' was causing
 panic.  Just go ahead and return, we need to ignore AUX iLO devs.

 Oops: 0002 [#1] SMP
   .
   .
   .
 RIP  [<ffffffffa033e270>] ilo_probe+0xec/0xe7c [hpilo]

Signed-off-by: Mark Rusk <mark.rusk@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/hpilo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 621c7a3..b83e3ca 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -759,7 +759,7 @@ static int ilo_probe(struct pci_dev *pdev,
 
 	/* Ignore subsystem_device = 0x1979 (set by BIOS)  */
 	if (pdev->subsystem_device == 0x1979)
-		goto out;
+		return 0;
 
 	if (max_ccb > MAX_CCB)
 		max_ccb = MAX_CCB;
@@ -899,7 +899,7 @@ static void __exit ilo_exit(void)
 	class_destroy(ilo_class);
 }
 
-MODULE_VERSION("1.4");
+MODULE_VERSION("1.4.1");
 MODULE_ALIAS(ILO_NAME);
 MODULE_DESCRIPTION(ILO_NAME);
 MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
-- 
1.8.1.2

