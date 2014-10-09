Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaJIVL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59670 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaJIVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/163] [media] cx18: fix kernel oops with tda8290 tuner
Date: Thu,  9 Oct 2014 14:01:47 -0700
Message-Id: <1412888588-26755-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 6a03dc92cc2edfa2257502557b9f714893987383 upstream.

This was caused by an uninitialized setup.config field.

Based on a suggestion from Devin Heitmueller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
Reported-by: Scott Robinson <scott.robinson55@gmail.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 716bdc5..83f5074 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1091,6 +1091,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 		setup.addr = ADDR_UNSET;
 		setup.type = cx->options.tuner;
 		setup.mode_mask = T_ANALOG_TV;  /* matches TV tuners */
+		setup.config = NULL;
 		if (cx->options.radio > 0)
 			setup.mode_mask |= T_RADIO;
 		setup.tuner_callback = (setup.type == TUNER_XC2028) ?
-- 
1.9.1

