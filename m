Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab3FAJkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:40:47 -0400
Received: from www17.your-server.de ([213.133.104.17]:58838 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab3FAJkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:40:39 -0400
Message-ID: <1370079631.29224.9.camel@localhost.localdomain>
Subject: [PATCH] HID: hyperv: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: kys@microsoft.com, haiyangz@microsoft.com, jkosina@suse.cz,
        devel@linuxdriverproject.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:40:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -199,13 +199,11 @@ static void mousevsc_on_receive_device_i
 	if (desc->bLength == 0)
 		goto cleanup;
 
-	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
+	input_device->hid_desc = kmemdup(desc, desc->bLength, GFP_ATOMIC);
 
 	if (!input_device->hid_desc)
 		goto cleanup;
 
-	memcpy(input_device->hid_desc, desc, desc->bLength);
-
 	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
 	if (input_device->report_desc_size == 0) {
 		input_device->dev_info_status = -EINVAL;


