Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbbALXFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:05:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41980 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbbALXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:05:04 -0500
Date: Mon, 12 Jan 2015 15:05:01 -0800 (PST)
X-Google-Original-Date: Tue, 13 Jan 2015 00:05 +0100
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, tj@kernel.org, stripathi@apm.com
Subject: Re: SATA link power management issues
Message-ID: <2526428.uJaEqCTeIa@xps13>
In-Reply-To: <3352987.ugV1Ipy7Z5@xps13>
References: <3352987.ugV1Ipy7Z5@xps13>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried the following and I no longer get errors:

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 97683e4..c815b31 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1708,10 +1708,10 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
 		status &= ~PORT_IRQ_BAD_PMP;
 
 	/* if LPM is enabled, PHYRDY doesn't mean anything */
-	if (ap->link.lpm_policy > ATA_LPM_MAX_POWER) {
+//	if (ap->link.lpm_policy > ATA_LPM_MAX_POWER) {
 		status &= ~PORT_IRQ_PHYRDY;
 		ahci_scr_write(&ap->link, SCR_ERROR, SERR_PHYRDY_CHG);
-	}
+// 	}
 
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);


I haven't read the specification, so this might be bad. I did this in
base of some consideration I made that, as far as I know, could be
completely wrong. I hope you can get something meaningful out of this.

Gabriele
