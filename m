Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaERQCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:02:13 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34524 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaERQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:02:12 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marta Rybczynska <rybczynska@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pci: hotplug: cpqphp_ctrl.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:02:57 +0200
Message-Id: <1400428977-10464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pci/hotplug/cpqphp_ctrl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index 11845b7..a319d07 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -709,7 +709,8 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
 				temp = temp->next;
 			}
 
-			temp->next = max->next;
+			if(temp)
+				temp->next = max->next;
 		}
 
 		max->next = NULL;
-- 
1.7.10.4

