Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaCCABE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:04 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61592 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaCCABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:01 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5 v2] staging: cxt1e1: fix checkpatch errors with open brace '{'
Date: Mon, 03 Mar 2014 09:00:57 +0900
Message-ID: <1997886.JHGKgWyC1A@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl error:
 ERROR: that open brace { should be on the previous line

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |   62 +++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 5f0e05d..d87a011 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -58,8 +58,7 @@ show_two(hdw_info_t *hi, int brdno)
 
 	ci = (ci_t *)(netdev_priv(hi->ndev));
 	bid = sbeid_get_bdname(ci);
-	switch (hi->promfmt)
-	{
+	switch (hi->promfmt) {
 	case PROM_FORMAT_TYPE1:
 		memcpy(sn, (FLD_TYPE1 *)(hi->mfg_info.pft1.Serial), 6);
 		break;
@@ -159,8 +158,7 @@ prep_hdw_info(void)
 	hdw_info_t *hi;
 	int         i;
 
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		hi->pci_busno = 0xff;
 		hi->pci_slot = 0xff;
 		hi->pci_pin[0] = 0;
@@ -179,18 +177,15 @@ cleanup_ioremap(void)
 	hdw_info_t *hi;
 	int         i;
 
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		if (hi->pci_slot == 0xff)
 			break;
-		if (hi->addr_mapped[0])
-		{
+		if (hi->addr_mapped[0]) {
 			iounmap((void *)(hi->addr_mapped[0]));
 			release_mem_region((long) hi->addr[0], hi->len[0]);
 			hi->addr_mapped[0] = 0;
 		}
-		if (hi->addr_mapped[1])
-		{
+		if (hi->addr_mapped[1]) {
 			iounmap((void *)(hi->addr_mapped[1]));
 			release_mem_region((long) hi->addr[1], hi->len[1]);
 			hi->addr_mapped[1] = 0;
@@ -205,8 +200,7 @@ cleanup_devs(void)
 	hdw_info_t *hi;
 	int         i;
 
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		if (hi->pci_slot == 0xff || !hi->ndev)
 			break;
 		c4_stopwd(netdev_priv(hi->ndev));
@@ -252,8 +246,7 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	 * element, identified by "slot==(0xff)".  The second part of a board's
 	 * functionality will match the previously loaded slot/busno.
 	 */
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		/*
 		 * match with board's first found interface, otherwise this is
 		 * fisrt found
@@ -262,17 +255,19 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 		    ((hi->pci_slot == slot) && (hi->bus == pdev->bus)))
 			break;                  /* found for-loop exit */
 	}
-	if (i == MAX_BOARDS)            /* no match in above loop means MAX
-					 * exceeded */
-	{
+
+	/* no match in above loop means MAX exceeded */
+	if (i == MAX_BOARDS) {
 		pr_warning("exceeded number of allowed devices (>%d)?\n",
 			   MAX_BOARDS);
 		return 0;
 	}
+
 	if (pdev->bus)
 		hi->pci_busno = pdev->bus->number;
 	else
 		hi->pci_busno = 0; /* default for system PCI inconsistency */
+
 	hi->pci_slot = slot;
 	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &hi->pci_pin[fun]);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &hi->revid[fun]);
@@ -311,43 +306,38 @@ c4hw_attach_all(void)
 	/*** scan PCI bus for all possible boards */
 	while ((pdev = pci_get_device(PCI_VENDOR_ID_CONEXANT,
 				      PCI_DEVICE_ID_CN8474,
-				      pdev)))
-	{
+				      pdev))) {
 		if (c4_hdw_init(pdev, found))
 			found++;
 	}
-	if (!found)
-	{
+
+	if (!found) {
 		pr_warning("No boards found\n");
 		return -ENODEV;
 	}
+
 	/* sanity check for consistent hardware found */
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
-		if (hi->pci_slot != 0xff && (!hi->addr[0] || !hi->addr[1]))
-		{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
+		if (hi->pci_slot != 0xff && (!hi->addr[0] || !hi->addr[1])) {
 			pr_warning("%s: something very wrong with pci_get_device\n",
 				   hi->devname);
 			return -EIO;
 		}
 	}
 	/* bring board's memory regions on/line */
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		if (hi->pci_slot == 0xff)
 			break;
-		for (j = 0; j < 2; j++)
-		{
-			if (!request_mem_region(hi->addr[j], hi->len[j], hi->devname))
-			{
+		for (j = 0; j < 2; j++) {
+			if (!request_mem_region(hi->addr[j], hi->len[j], hi->devname)) {
 				pr_warning("%s: memory in use, addr=0x%lx, len=0x%lx ?\n",
 					   hi->devname, hi->addr[j], hi->len[j]);
 				cleanup_ioremap();
 				return -ENOMEM;
 			}
+
 			hi->addr_mapped[j] = (unsigned long)ioremap(hi->addr[j], hi->len[j]);
-			if (!hi->addr_mapped[j])
-			{
+			if (!hi->addr_mapped[j]) {
 				pr_warning("%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
 					   hi->devname, hi->addr[j], hi->len[j]);
 				cleanup_ioremap();
@@ -364,13 +354,11 @@ c4hw_attach_all(void)
 	drvr_state = SBE_DRVR_AVAILABLE;
 
 	/* Have now memory mapped all boards.  Now allow board's access to system */
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
 		if (hi->pci_slot == 0xff)
 			break;
 		if (pci_enable_device(hi->pdev[0]) ||
-		    pci_enable_device(hi->pdev[1]))
-		{
+		    pci_enable_device(hi->pdev[1])) {
 			drvr_state = SBE_DRVR_DOWN;
 			pr_warning("%s: failed to enable card %d slot %d\n",
 				   hi->devname, i, hi->pci_slot);
-- 
1.7.9.5


