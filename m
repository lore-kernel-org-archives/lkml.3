Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3KRNds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:48 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57641 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 02/10] mfd: intel: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:32:58 +0100
Message-Id: <1384781586-4798-2-git-send-email-geert@linux-m68k.org>
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

 drivers/mfd/intel_msic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 9203d47cdbb1..049fd23af54a 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -178,7 +178,7 @@ static struct mfd_cell msic_devs[] = {
  * These devices appear only after the MSIC driver itself is initialized so
  * we can guarantee that the SCU IPC interface is ready.
  */
-static struct mfd_cell msic_other_devs[] = {
+static const struct mfd_cell msic_other_devs[] = {
 	/* Audio codec in the MSIC */
 	{
 		.id			= -1,
-- 
1.7.9.5

