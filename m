Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3KRNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:55 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57676 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 07/10] mfd: toshiba: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:03 +0100
Message-Id: <1384781586-4798-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
mfd_add_devices() is "const" again. Hence make all cell data passed to
mfd_add_devices() const where possible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Split in groups

 drivers/mfd/tc3589x.c  |    4 ++--
 drivers/mfd/tc6387xb.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 87ea51dc6234..2cf636c267d9 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -155,7 +155,7 @@ static struct resource keypad_resources[] = {
 	},
 };
 
-static struct mfd_cell tc3589x_dev_gpio[] = {
+static const struct mfd_cell tc3589x_dev_gpio[] = {
 	{
 		.name		= "tc3589x-gpio",
 		.num_resources	= ARRAY_SIZE(gpio_resources),
@@ -164,7 +164,7 @@ static struct mfd_cell tc3589x_dev_gpio[] = {
 	},
 };
 
-static struct mfd_cell tc3589x_dev_keypad[] = {
+static const struct mfd_cell tc3589x_dev_keypad[] = {
 	{
 		.name           = "tc3589x-keypad",
 		.num_resources  = ARRAY_SIZE(keypad_resources),
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index acd0f3a41044..591a331d8d83 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -126,7 +126,7 @@ static struct tmio_mmc_data tc6387xb_mmc_data = {
 
 /*--------------------------------------------------------------------------*/
 
-static struct mfd_cell tc6387xb_cells[] = {
+static const struct mfd_cell tc6387xb_cells[] = {
 	[TC6387XB_CELL_MMC] = {
 		.name = "tmio-mmc",
 		.enable = tc6387xb_mmc_enable,
-- 
1.7.9.5

