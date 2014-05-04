Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaEDQuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:50:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaEDPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 050/158] mfd: twl-core: Fix accessibility of some twl4030 audio registers
Date: Sun,  4 May 2014 11:39:19 -0400
Message-Id: <20140504154036.794192030@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Novotny <tomas@novotny.cz>

commit 56816b700c8c773270f3aaf4c92be53e359a03fd upstream.

There are some unused registers in twl4030 at I2C address 0x49 and function
twl4030_49_nop_reg() is used to check accessibility of that registers. These
registers are written in decimal format but the values are correct in
hexadecimal format. (It can be checked few lines above the patched code -
these registers are marked as unused there.)

As a consequence three registers of audio submodule are treated as
inaccessible (preamplifier carkit right and both handsfree registers).

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/twl-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -282,11 +282,11 @@ static struct reg_default twl4030_49_def
 static bool twl4030_49_nop_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case 0:
-	case 3:
-	case 40:
-	case 41:
-	case 42:
+	case 0x00:
+	case 0x03:
+	case 0x40:
+	case 0x41:
+	case 0x42:
 		return false;
 	default:
 		return true;


