Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3EJOge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:36:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181Ab3EJOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yogesh Ashok Powar" <yogeshp@marvell.com>,
        "Bing Zhao" <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Amitkumar Karwar" <akarwar@marvell.com>,
        "Avinash Patil" <patila@marvell.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.542765907@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [063/118] mwifiex: Call pci_release_region after calling
 pci_disable_device
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Ashok Powar <yogeshp@marvell.com>

commit 5b0d9b218b74042ff72bf4bfda6eeb2e4bf98397 upstream.

"drivers should call pci_release_region() AFTER
calling pci_disable_device()"

Please refer section 3.2 Request MMIO/IOP resources
in Documentation/PCI/pci.txt

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1821,9 +1821,9 @@ static void mwifiex_pcie_cleanup(struct
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
+		pci_disable_device(pdev);
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 0);
-		pci_disable_device(pdev);
 		pci_set_drvdata(pdev, NULL);
 	}
 }

