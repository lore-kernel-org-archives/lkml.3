Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab3K0B0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:26:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab3K0A67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonas Hahnfeld <linux@hahnjo.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 011/116] alx: Reset phy speed after resume
Date: Tue, 26 Nov 2013 16:56:24 -0800
Message-Id: <20131127005737.703154926@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hahnjo <hahnjo@hahnjo.de>

commit b54629e226d196e802abdd30c5e34f2a47cddcf2 upstream.

This fixes bug 62491 (https://bugzilla.kernel.org/show_bug.cgi?id=62491).
After resuming some users got the following error flooding the kernel log:
alx 0000:02:00.0: invalid PHY speed/duplex: 0xffff

Signed-off-by: Jonas Hahnfeld <linux@hahnjo.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: hahnjo <linux@hahnjo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/atheros/alx/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1389,6 +1389,9 @@ static int alx_resume(struct device *dev
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct alx_priv *alx = pci_get_drvdata(pdev);
+	struct alx_hw *hw = &alx->hw;
+
+	alx_reset_phy(hw);
 
 	if (!netif_running(alx->dev))
 		return 0;


