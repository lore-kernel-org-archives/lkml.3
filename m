Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422751Ab3BAKvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:51:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:39219 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422738Ab3BAKvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Borislav Petkov <bp@suse.de>
Subject: [ 22/33] EDAC: Test correct variable in ->store function
Date: Fri,  1 Feb 2013 11:49:27 +0100
Message-Id: <20130201104726.235135333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8024c4c0b1057d1cd811fc9c3f88f81de9729fcd upstream.

We're testing for ->show but calling ->store().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_pci_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -257,7 +257,7 @@ static ssize_t edac_pci_dev_store(struct
 	struct edac_pci_dev_attribute *edac_pci_dev;
 	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
 
-	if (edac_pci_dev->show)
+	if (edac_pci_dev->store)
 		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
 	return -EIO;
 }


