Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbbATMzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:55:03 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:52023 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbATMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:55:00 -0500
Subject: [RESEND PATCH] pnpbios: bail out on strange errors
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 12:54:50 +0000
Message-ID: <20150120125429.8451.39702.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small number of systems respond to PnP dock queries with bogus values.
This causes us to keep logging an error every 2 seconds. Instead of trying
again just assume the BIOS is crapware and doesn't actually have dock
functionality.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pnp/pnpbios/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 074569e..facd43b 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -181,7 +181,8 @@ static int pnp_dock_thread(void *unused)
 			break;
 		default:
 			pnpbios_print_status("pnp_dock_thread", status);
-			continue;
+			printk(KERN_WARNING "PnPBIOS: disabling dock monitoring.\n");
+			complete_and_exit(&unload_sem, 0);
 		}
 		if (d != docked) {
 			if (pnp_dock_event(d, &now) == 0) {

