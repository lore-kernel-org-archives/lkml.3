Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaG2MAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:00:01 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51671 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbaG2L6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:50 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] staging: comedi: amplc_pci230: no need to initialize named members to zero
Date: Tue, 29 Jul 2014 12:58:25 +0100
Message-Id: <1406635107-27950-18-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The members of the elements of `pci230_boards[]` that are not explicitly
named in their initializers will be initialized to 0 automatically, so
there is no need to initialize them to 0 explicitly.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 47e10ba..135ca63 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -484,9 +484,6 @@ static const struct pci230_board pci230_boards[] = {
 		.id		= PCI_DEVICE_ID_PCI260,
 		.ai_chans	= 16,
 		.ai_bits	= 16,
-		.ao_chans	= 0,
-		.ao_bits	= 0,
-		.have_dio	= 0,
 		.min_hwver	= 1,
 	},
 	{
@@ -503,9 +500,6 @@ static const struct pci230_board pci230_boards[] = {
 		.id		= PCI_DEVICE_ID_PCI260,
 		.ai_chans	= 16,
 		.ai_bits	= 12,
-		.ao_chans	= 0,
-		.ao_bits	= 0,
-		.have_dio	= 0,
 	},
 	{
 		/* Wildcard matches any above */
-- 
2.0.0

