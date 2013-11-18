Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3KRNdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:32 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57660 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 06/10] mfd: ti: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:02 +0100
Message-Id: <1384781586-4798-6-git-send-email-geert@linux-m68k.org>
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

 drivers/mfd/tps6507x.c      |    2 +-
 drivers/mfd/tps65090.c      |    2 +-
 drivers/mfd/tps65217.c      |    2 +-
 drivers/mfd/tps6586x.c      |    2 +-
 drivers/mfd/tps65910.c      |    2 +-
 drivers/mfd/tps65912-core.c |    2 +-
 drivers/mfd/tps80031.c      |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index a081b925d10b..3b27482a174f 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6507x.h>
 
-static struct mfd_cell tps6507x_devs[] = {
+static const struct mfd_cell tps6507x_devs[] = {
 	{
 		.name = "tps6507x-pmic",
 	},
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index e6f03a733879..ba1a25d758c1 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -64,7 +64,7 @@ static struct resource charger_resources[] = {
 	}
 };
 
-static struct mfd_cell tps65090s[] = {
+static const struct mfd_cell tps65090s[] = {
 	{
 		.name = "tps65090-pmic",
 	},
diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index b7be0b295575..6939ae56c2e1 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -30,7 +30,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65217.h>
 
-static struct mfd_cell tps65217s[] = {
+static const struct mfd_cell tps65217s[] = {
 	{
 		.name = "tps65217-pmic",
 	},
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index ee61fd7c198d..d0e57934370f 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -103,7 +103,7 @@ static struct resource tps6586x_rtc_resources[] = {
 	},
 };
 
-static struct mfd_cell tps6586x_cell[] = {
+static const struct mfd_cell tps6586x_cell[] = {
 	{
 		.name = "tps6586x-gpio",
 	},
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index c0f608e3ca9e..1f142d76cbbc 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -36,7 +36,7 @@ static struct resource rtc_resources[] = {
 	}
 };
 
-static struct mfd_cell tps65910s[] = {
+static const struct mfd_cell tps65910s[] = {
 	{
 		.name = "tps65910-gpio",
 	},
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 925a044cbdf6..27a518e0eec6 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -21,7 +21,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps65912.h>
 
-static struct mfd_cell tps65912s[] = {
+static const struct mfd_cell tps65912s[] = {
 	{
 		.name = "tps65912-pmic",
 	},
diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index f15ee6d5cfbf..ed6c5b0956e2 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -44,7 +44,7 @@ static struct resource tps80031_rtc_resources[] = {
 };
 
 /* TPS80031 sub mfd devices */
-static struct mfd_cell tps80031_cell[] = {
+static const struct mfd_cell tps80031_cell[] = {
 	{
 		.name = "tps80031-pmic",
 	},
-- 
1.7.9.5

