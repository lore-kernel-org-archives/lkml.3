Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbaGPABJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:01:09 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36215 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185AbaGPABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:01:05 -0400
Date: Tue, 15 Jul 2014 20:00:54 -0400
From: Michael Mullin <masmullin@gmail.com>
To: olof@lixom.net
Cc: bleung@chromium.org, linux-kernel@vger.kernel.org, dparker@chromium.org
Subject: [PATCH] Add support for the acer c720p touchscreen.
Message-ID: <20140716000054.GA1192@mars.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the acer c720p touchscreen.
Tested manually by using the touchscreen on the acer c720p-2664

Based on the following patch by Dave Parker <dparker@chromium.org>:
https://chromium-review.googlesource.com/#/c/167136/

Signed-off-by: Michael Mullin <masmullin@gmail.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index a53fe76..15b1b16 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -419,6 +419,8 @@ static struct chromeos_laptop acer_ac700 = {
 
 static struct chromeos_laptop acer_c720 = {
 	.i2c_peripherals = {
+		/* Touchscreen. */
+		{ .add = setup_atmel_1664s_ts, I2C_ADAPTER_DESIGNWARE_1 },
 		/* Touchpad. */
 		{ .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
 		/* Light Sensor. */
-- 
2.0.1

