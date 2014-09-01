Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaIALE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39012 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaIALEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/28] staging: comedi: amplc_pci230: shrink struct pci230_board
Date: Mon,  1 Sep 2014 12:03:45 +0100
Message-Id: <1409569440-10979-14-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `ai_bits`, `ao_bits`, and `min_hwver` members of `struct
pci230_board` are only set to small, non-negative values, so make them
`unsigned char`.  The `have_dio` member is used as a boolean so change
it to a bitfield of type `bool`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 75b0e79..7fa9c70 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -454,10 +454,10 @@ enum {
 struct pci230_board {
 	const char *name;
 	unsigned short id;
-	int ai_bits;
-	int ao_bits;
-	int have_dio;
-	unsigned int min_hwver;	/* Minimum hardware version supported. */
+	unsigned char ai_bits;
+	unsigned char ao_bits;
+	unsigned char min_hwver; /* Minimum hardware version supported. */
+	bool have_dio:1;
 };
 
 static const struct pci230_board pci230_boards[] = {
@@ -466,7 +466,7 @@ static const struct pci230_board pci230_boards[] = {
 		.id		= PCI_DEVICE_ID_PCI230,
 		.ai_bits	= 16,
 		.ao_bits	= 12,
-		.have_dio	= 1,
+		.have_dio	= true,
 		.min_hwver	= 1,
 	},
 	{
@@ -480,7 +480,7 @@ static const struct pci230_board pci230_boards[] = {
 		.id		= PCI_DEVICE_ID_PCI230,
 		.ai_bits	= 12,
 		.ao_bits	= 12,
-		.have_dio	= 1,
+		.have_dio	= true,
 	},
 	{
 		.name		= "pci260",
-- 
2.0.4

