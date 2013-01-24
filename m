Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3AXDmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:42:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3AXD3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 27/74] staging: comedi: fix minimum AO period for NI 625x and NI 628x
Date: Thu, 24 Jan 2013 01:26:39 -0200
Message-Id: <1358998046-613-28-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?=C3=89ric=20Piel?= <piel@delmic.com>

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 3974c0d..fa09fd7 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -963,7 +963,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -982,7 +982,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1001,7 +1001,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1037,7 +1037,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1056,7 +1056,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_625x_ao,
 	 .reg_type = ni_reg_625x,
 	 .ao_unipolar = 0,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1092,7 +1092,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1111,7 +1111,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 8,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
@@ -1147,7 +1147,7 @@ static const struct ni_board_struct ni_boards[] = {
 	 .ao_range_table = &range_ni_M_628x_ao,
 	 .reg_type = ni_reg_628x,
 	 .ao_unipolar = 1,
-	 .ao_speed = 357,
+	 .ao_speed = 350,
 	 .num_p0_dio_channels = 32,
 	 .caldac = {caldac_none},
 	 .has_8255 = 0,
-- 
1.7.9.5

