Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBMF2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:28:12 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52774 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaBMF2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:28:07 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] Input: synaptics-rmi4 - remove control_mutex from f01_data
Date: Wed, 12 Feb 2014 21:27:51 -0800
Message-Id: <1392269277-16391-5-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used by anyone.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_f01.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 30e0b50..6f90a6c 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -125,7 +125,6 @@ struct f01_data {
 	struct f01_basic_properties properties;
 
 	struct f01_device_control device_control;
-	struct mutex control_mutex;
 
 	u8 device_status;
 
@@ -214,8 +213,6 @@ static int rmi_f01_initialize(struct rmi_function *fn)
 	struct f01_data *data = fn->data;
 	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
 
-	mutex_init(&data->control_mutex);
-
 	/*
 	 * Set the configured bit and (optionally) other important stuff
 	 * in the device control register.
-- 
1.8.5.3

