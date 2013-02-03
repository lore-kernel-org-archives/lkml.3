Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3BCO6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34519 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab3BCO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:54 -0500
Message-Id: <20130203144653.208605057@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>
Subject: [ 104/128] EDAC: Test correct variable in ->store function
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8024c4c0b1057d1cd811fc9c3f88f81de9729fcd upstream.

We're testing for ->show but calling ->store().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/edac/edac_pci_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index dc6e905..0056c4d 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -256,7 +256,7 @@ static ssize_t edac_pci_dev_store(struct kobject *kobj,
 	struct edac_pci_dev_attribute *edac_pci_dev;
 	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
 
-	if (edac_pci_dev->show)
+	if (edac_pci_dev->store)
 		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
 	return -EIO;
 }


