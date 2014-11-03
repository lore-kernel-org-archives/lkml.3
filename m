Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaKCJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:52:16 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62011 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbaKCJwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:52:15 -0500
Message-ID: <1415008333.20372.26.camel@x220>
Subject: [PATCH] [TRIVIAL] IBM Akebono: Remove select of IBM_EMAC_RGMII_WOL
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Alistair Popple <alistair@popple.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 10:52:13 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2014 09:52:13.0699 (UTC) FILETIME=[D8166D30:01CFF74B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2a2c74b2efcb ("IBM Akebono: Add the Akebono platform") added a
select of IBM_EMAC_RGMII_WOL. But that Kconfig symbol isn't (yet) part
of the tree. So this select has been a nop since that commit was
included in v3.16-rc1.

The code to add this symbol is not included in next-20141103. So let's
remove this select. It can be readded when that symbol is actually added
to the tree.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Alistair Popple <alistair@popple.id.au>
---
Untested. Done on top of next-20141103.

Third time's a charm? First raised in
https://lkml.org/lkml/2014/5/1/106 . Reminder sent in
https://lkml.org/lkml/2014/9/4/645 . I'm not aware of any news on this
front, so this trivial patch seems reasonable now.

A patch to readd this select could be added - if people still care about
it, that is - in the series that adds this symbol. A web search suggests
Alistair takes care of that series, so Alistair gets a Cc: here.

 arch/powerpc/platforms/44x/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index d2ac1c116454..5538e57c36c1 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -214,7 +214,6 @@ config AKEBONO
 	select ETHERNET
 	select NET_VENDOR_IBM
 	select IBM_EMAC_EMAC4
-	select IBM_EMAC_RGMII_WOL
 	select USB if USB_SUPPORT
 	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
 	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
-- 
1.9.3

