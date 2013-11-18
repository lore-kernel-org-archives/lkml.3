Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3KRNeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:34:08 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57643 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 03/10] mfd: marvell: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:32:59 +0100
Message-Id: <1384781586-4798-3-git-send-email-geert@linux-m68k.org>
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

 drivers/mfd/88pm800.c |    4 ++--
 drivers/mfd/88pm805.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index a65447d65605..7dca1e640970 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -148,7 +148,7 @@ static struct resource onkey_resources[] = {
 	 },
 };
 
-static struct mfd_cell onkey_devs[] = {
+static const struct mfd_cell onkey_devs[] = {
 	{
 	 .name = "88pm80x-onkey",
 	 .num_resources = 1,
@@ -157,7 +157,7 @@ static struct mfd_cell onkey_devs[] = {
 	 },
 };
 
-static struct mfd_cell regulator_devs[] = {
+static const struct mfd_cell regulator_devs[] = {
 	{
 	 .name = "88pm80x-regulator",
 	 .id = -1,
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 8a5b6ffb5afb..64751c2a1ace 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -77,7 +77,7 @@ static struct resource codec_resources[] = {
 	 },
 };
 
-static struct mfd_cell codec_devs[] = {
+static const struct mfd_cell codec_devs[] = {
 	{
 	 .name = "88pm80x-codec",
 	 .num_resources = ARRAY_SIZE(codec_resources),
-- 
1.7.9.5

