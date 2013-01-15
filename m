Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3AOWu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:46194 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305Ab3AOWuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?=C3=89ric=20Piel?= <piel@delmic.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 081/171] staging: comedi: fix minimum AO period for NI 625x and NI 628x
Date: Tue, 15 Jan 2013 14:44:06 -0800
Message-Id: <20130115224319.246625270@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/ni_pcimio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1023,7 +1023,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1042,7 +1042,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1061,7 +1061,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1097,7 +1097,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1116,7 +1116,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1152,7 +1152,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1171,7 +1171,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1207,7 +1207,7 @@ static const struct ni_board_struct ni_b
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,


