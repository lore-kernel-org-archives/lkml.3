Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3IEUhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:37:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3IEU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rusk <mark.rusk@hp.com>
Subject: [ 33/36] drivers/misc/hpilo: Correct panic when an AUX iLO is detected
Date: Thu,  5 Sep 2013 13:28:02 -0700
Message-Id: <20130905202706.163391177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/misc/hpilo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -759,7 +759,7 @@ static int ilo_probe(struct pci_dev *pde
 
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


