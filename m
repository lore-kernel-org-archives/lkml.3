Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FDWm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35588 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab3FDWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:51 -0400
Message-Id: <20130604172134.083560877@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Thomas Bork <tom@eisfair.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 091/184] r8169: Add support for D-Link 530T rev C1 (Kernel
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 Bug 38862)

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

[ Upstream commit 93a3aa25933461d76141179fc94aa32d5f9d954a ]

The D-Link DGE-530T rev C1 is a re-badged Realtek 8169 named DLG10028C,
unlike the previous revisions which were skge based.  It is probably
the same as the discontinued DGE-528T (0x4300) other than the PCI ID.

The PCI ID is 0x1186:0x4302.

Adding it to r8169.c where 0x1186:0x4300 is already found makes the card
be detected and work.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=38862

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 7106159f8bd33bd5e5b0ea2c87e499117fc22c69)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/r8169.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b22623d..2d89062 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -176,6 +176,7 @@ static struct pci_device_id rtl8169_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4302), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(0x16ec,			0x0116), 0, 0, RTL_CFG_0 },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
-- 
1.7.12.2.21.g234cd45.dirty



