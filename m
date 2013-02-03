Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3BCPWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:22:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34129 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405Ab3BCOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:07 -0500
Message-Id: <20130203144646.088008213@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 023/128] staging: comedi: fix minimum AO period for NI 625x and NI 628x
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Éric Piel <piel@delmic.com>

commit 34b55d8c48f4f76044d8f4d6ec3dc786cf210312 upstream.

The minimum period was set to 357 ns, while the divider for these boards is 50
ns. This prevented to output at maximum speed as ni_ao_cmdtest() would return
357 but would not accept it.

Not sure why it was set to 357 ns (this was done before the git history,
which starts 5 years ago). My guess is that it comes from reading the
specification stating a 2.8 MHz rate (~ 357 ns). The latest
specification states a 2.86 MHz rate (~ 350 ns), which makes a lot
more sense.

Tested on a pci-6251.

Signed-off-by: Éric Piel <piel@delmic.com>
Acked-By: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: drop hunk for a board that's not listed]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1021,7 +1021,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1040,7 +1040,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1076,7 +1076,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1095,7 +1095,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1131,7 +1131,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1150,7 +1150,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1186,7 +1186,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,


