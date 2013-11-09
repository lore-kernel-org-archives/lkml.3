Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab3KIHMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:12:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab3KIGwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.11 38/94] Revert "rt2x00pci: Use PCI MSIs whenever possible"
Date: Fri,  8 Nov 2013 22:51:44 -0800
Message-Id: <20131109065206.922948634@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit dfb6b7c109a7f98d324a759599d1b4616f02c79f upstream.

This reverts commit 9483f40d8d01918b399b4e24d0c1111db0afffeb.

Some devices stop to connect with above commit, see:
https://bugzilla.kernel.org/show_bug.cgi?id=61621

Since there is no clear benefit of having MSI enabled, just revert
change to fix the problem.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -105,13 +105,11 @@ int rt2x00pci_probe(struct pci_dev *pci_
 		goto exit_release_regions;
 	}
 
-	pci_enable_msi(pci_dev);
-
 	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
 	if (!hw) {
 		rt2x00_probe_err("Failed to allocate hardware\n");
 		retval = -ENOMEM;
-		goto exit_disable_msi;
+		goto exit_release_regions;
 	}
 
 	pci_set_drvdata(pci_dev, hw);
@@ -152,9 +150,6 @@ exit_free_reg:
 exit_free_device:
 	ieee80211_free_hw(hw);
 
-exit_disable_msi:
-	pci_disable_msi(pci_dev);
-
 exit_release_regions:
 	pci_release_regions(pci_dev);
 
@@ -179,8 +174,6 @@ void rt2x00pci_remove(struct pci_dev *pc
 	rt2x00pci_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
-	pci_disable_msi(pci_dev);
-
 	/*
 	 * Free the PCI device data.
 	 */


