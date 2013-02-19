Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3BSEJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:09:18 -0500
Received: from mout.gmx.net ([212.227.15.18]:52687 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab3BSEJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:09:17 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/DcaMRBiTDuUVVKsx+kiaTvfXoCPCFrWGxMhEz87
	7t+eBxv/9vOH6U
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging/slicoss: Check pointer before dereferencing
Date: Tue, 19 Feb 2013 05:13:50 +0100
Message-Id: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains that the variable adapter is dereferenced before it is
checked:
slicoss.c:906 slic_timer_load_check() warn: variable dereferenced before
check 'adapter' (see line 904)

-> move the assignment after the check.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/slicoss/slicoss.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 76fc2e5..753993c 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -901,10 +901,9 @@ static void slic_timer_load_check(ulong cardaddr)
 	u32 load = card->events;
 	u32 level = 0;
 
-	intagg = &adapter->slic_regs->slic_intagg;
-
 	if ((adapter) && (adapter->state == ADAPT_UP) &&
 	    (card->state == CARD_UP) && (slic_global.dynamic_intagg)) {
+		intagg = &adapter->slic_regs->slic_intagg;
 		if (adapter->devid == SLIC_1GB_DEVICE_ID) {
 			if (adapter->linkspeed == LINK_1000MB)
 				level = 100;
-- 
1.7.8.6

