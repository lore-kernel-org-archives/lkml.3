Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3BBUqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:46:07 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:58729 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3BBUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:45:59 -0500
From: Paul Sbarra <sbarra.paul@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Sbarra <sbarra.paul@gmail.com>
Subject: [PATCH 3/3] hid: Calibrate Logitech Driving Force axes
Date: Sat,  2 Feb 2013 14:45:25 -0600
Message-Id: <1359837925-6383-3-git-send-email-sbarra.paul@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
References: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conflicts:
	drivers/hid/hid-lg.c

Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
---
 drivers/hid/hid-lg.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 4bc0e1b..6f2067f 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -60,16 +60,14 @@ static __u8 df_rdesc_fixed[] = {
 0xA1, 0x02,         /*      Collection (Logical),               */
 0x95, 0x01,         /*          Report Count (1),               */
 0x75, 0x0A,         /*          Report Size (10),               */
-0x14,               /*          Logical Minimum (0),            */
-0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),         */
-0x34,               /*          Physical Minimum (0),           */
-0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),        */
+0x15, 45,           /*          Logical Minimum (45),           */
+0x26, 0xA7, 0x03,   /*          Logical Maximum (935),          */
 0x09, 0x30,         /*          Usage (X),                      */
 0x81, 0x02,         /*          Input (Variable),               */
 0x95, 0x0C,         /*          Report Count (12),              */
 0x75, 0x01,         /*          Report Size (1),                */
+0x14,               /*          Logical Minimum (0),            */
 0x25, 0x01,         /*          Logical Maximum (1),            */
-0x45, 0x01,         /*          Physical Maximum (1),           */
 0x05, 0x09,         /*          Usage (Buttons),                */
 0x19, 0x01,         /*          Usage Minimum (1),              */
 0x29, 0x0c,         /*          Usage Maximum (12),             */
@@ -80,7 +78,6 @@ static __u8 df_rdesc_fixed[] = {
 0x81, 0x02,         /*          Input (Variable),               */
 0x05, 0x01,         /*          Usage Page (Desktop),           */
 0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
-0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
 0x95, 0x01,         /*          Report Count (1),               */
 0x75, 0x08,         /*          Report Size (8),                */
 0x81, 0x02,         /*          Input (Variable),               */
@@ -95,16 +92,18 @@ static __u8 df_rdesc_fixed[] = {
 0x65, 0x00,         /*          Unit (none),                    */
 0x06, 0x00, 0xFF,   /*          Usage Page (Vendor: 65280),     */
 0x09, 0x01,         /*          Usage (?: 1),                   */
+0x44,               /*          Physical Maximum (0),           */
 0x25, 0x01,         /*          Logical Maximum (1),            */
-0x45, 0x01,         /*          Physical Maximum (1),           */
 0x81, 0x02,         /*          Input (Variable),               */
 0x05, 0x01,         /*          Usage Page (Desktop),           */
 0x95, 0x01,         /*          Report Count (1),               */
 0x75, 0x08,         /*          Report Size (8),                */
-0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
-0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x15, 30,           /*          Logical Minimum (30),           */
+0x25, 180,          /*          Logical Maximum (180),          */
 0x09, 0x31,         /*          Usage (Y),                      */
 0x81, 0x02,         /*          Input (Variable),               */
+0x15, 70,           /*          Logical Minimum (70),           */
+0x25, 215,          /*          Logical Maximum (215),          */
 0x09, 0x35,         /*          Usage (Rz),                     */
 0x81, 0x02,         /*          Input (Variable),               */
 0xC0,               /*      End Collection,                     */
-- 
1.8.1.1

