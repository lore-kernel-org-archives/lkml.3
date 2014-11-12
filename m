Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaKLDEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:04:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170AbaKLBjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:39:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "D. Jared Dominguez" <Jared_Dominguez@Dell.com>,
        Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 050/203] mfd: rtsx_pcr: Fix MSI enable error handling
Date: Wed, 12 Nov 2014 10:15:20 +0900
Message-Id: <20141112011544.996961793@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <chris@printf.net>

commit 5152970538a5e16c03bbcb9f1c780489a795ed40 upstream.

pci_enable_msi() can return failure with both positive and negative
integers -- it returns 0 for success -- but is only tested here for
"if (ret < 0)".  This causes us to try to use MSI on the RTS5249 SD
reader in the Dell XPS 11 when enabling MSI failed, causing:

[    1.737110] rtsx_pci: probe of 0000:05:00.0 failed with error -110

Reported-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Tested-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rtsx_pcr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1177,7 +1177,7 @@ static int rtsx_pci_probe(struct pci_dev
 	pcr->msi_en = msi_en;
 	if (pcr->msi_en) {
 		ret = pci_enable_msi(pcidev);
-		if (ret < 0)
+		if (ret)
 			pcr->msi_en = false;
 	}
 


