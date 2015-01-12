Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbbALScw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:32:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbbALSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Mullin <masmullin@gmail.com>, Olof Johansson <olof@lixom.net>,
        Scot Doyle <lkml14@scotdoyle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 212/216] platform/chrome: Add support for the acer c720p touchscreen.
Date: Mon, 12 Jan 2015 18:29:50 +0000
Message-Id: <1421087394-2712-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Mullin <masmullin@gmail.com>

commit b90b3c4ae06af135e279c9a5aa1c640d22787fc4 upstream.

Add support for the acer c720p touchscreen.
Tested manually by using the touchscreen on the acer c720p-2664

Based on the following patch by Dave Parker <dparker@chromium.org>:
https://chromium-review.googlesource.com/#/c/167136/

Signed-off-by: Michael Mullin <masmullin@gmail.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 37fa570a7636..fd090efe5489 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -417,6 +417,8 @@ static struct chromeos_laptop acer_ac700 = {
 
 static struct chromeos_laptop acer_c720 = {
 	.i2c_peripherals = {
+		/* Touchscreen. */
+		{ .add = setup_atmel_1664s_ts, I2C_ADAPTER_DESIGNWARE_1 },
 		/* Touchpad. */
 		{ .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
 		/* Light Sensor. */
-- 
2.1.4

