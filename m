Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaG0AVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 20:21:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51922 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaG0AVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 20:21:41 -0400
From: Cihangir Akturk <cakturk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: peter.p.waskiewicz.jr@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Cihangir Akturk <cakturk@gmail.com>
Subject: [PATCH] staging: gdm724x: fix misplaced open braces
Date: Sun, 27 Jul 2014 03:21:15 +0300
Message-Id: <1406420475-14163-1-git-send-email-cakturk@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issues in gdm_usb.c:
ERROR: that open brace { should be on the previous line

Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
---
 drivers/staging/gdm724x/gdm_usb.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index 0c1b2de..483185b 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -264,28 +264,25 @@ static void release_usb(struct lte_udev *udev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tx->lock, flags);
-	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->sdu_list, list)
-	{
+	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->sdu_list, list) {
 		list_del(&t_sdu->list);
 		free_tx_sdu_struct(t_sdu);
 	}
 
-	list_for_each_entry_safe(t, t_next, &tx->hci_list, list)
-	{
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
 		list_del(&t->list);
 		free_tx_struct(t);
 	}
 
-	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->free_list, list)
-	{
+	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->free_list, list) {
 		list_del(&t_sdu->list);
 		free_tx_sdu_struct(t_sdu);
 	}
 	spin_unlock_irqrestore(&tx->lock, flags);
 
 	spin_lock_irqsave(&rx->submit_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list)
-	{
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list,
+				 rx_submit_list) {
 		spin_unlock_irqrestore(&rx->submit_lock, flags);
 		usb_kill_urb(r->urb);
 		spin_lock_irqsave(&rx->submit_lock, flags);
@@ -293,16 +290,14 @@ static void release_usb(struct lte_udev *udev)
 	spin_unlock_irqrestore(&rx->submit_lock, flags);
 
 	spin_lock_irqsave(&rx->rx_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->free_list, free_list)
-	{
+	list_for_each_entry_safe(r, r_next, &rx->free_list, free_list) {
 		list_del(&r->free_list);
 		free_rx_struct(r);
 	}
 	spin_unlock_irqrestore(&rx->rx_lock, flags);
 
 	spin_lock_irqsave(&rx->to_host_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->to_host_list, to_host_list)
-	{
+	list_for_each_entry_safe(r, r_next, &rx->to_host_list, to_host_list) {
 		if (r->index == (void *)udev) {
 			list_del(&r->to_host_list);
 			free_rx_struct(r);
@@ -458,9 +453,8 @@ static void remove_rx_submit_list(struct usb_rx *r, struct rx_cxt *rx)
 	struct usb_rx	*r_remove, *r_remove_next;
 
 	spin_lock_irqsave(&rx->submit_lock, flags);
-	list_for_each_entry_safe(r_remove,
-			r_remove_next, &rx->rx_submit_list, rx_submit_list)
-	{
+	list_for_each_entry_safe(r_remove, r_remove_next,
+				 &rx->rx_submit_list, rx_submit_list) {
 		if (r == r_remove) {
 			list_del(&r->rx_submit_list);
 			break;
@@ -938,8 +932,8 @@ static int gdm_usb_suspend(struct usb_interface *intf, pm_message_t pm_msg)
 	udev->usb_state = PM_SUSPEND;
 
 	spin_lock_irqsave(&rx->submit_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list)
-	{
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list,
+				 rx_submit_list) {
 		spin_unlock_irqrestore(&rx->submit_lock, flags);
 		usb_kill_urb(r->urb);
 		spin_lock_irqsave(&rx->submit_lock, flags);
-- 
1.9.3

