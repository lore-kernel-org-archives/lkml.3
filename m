Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbbANITd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:19:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbbANH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alison Chaiken <alison_chaiken@mentor.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.18 109/150] MTD: m25p80: fix inconsistency in m25p_ids compared to spi_nor_ids
Date: Tue, 13 Jan 2015 23:23:00 -0800
Message-Id: <20150114072100.803082483@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Chaiken <alison_chaiken@mentor.com>

commit 834b686552d9018e2d17bd56ac5361b78bcc75b8 upstream.

As stated in a5b7616c5, "mtd: m25p80,spi-nor: Fix module aliases for
m25p80", m25p_ids[] in m25p80.c needs to be kept in sync with
spi_nor_ids[] in spi-nor.c. The change here corrects a misalignment.

(We were missing m25px80 and we had a duplicate w25q128.)

Signed-off-by: Alison Chaiken <alison_chaiken@mentor.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/m25p80.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -300,11 +300,11 @@ static const struct spi_device_id m25p_i
 	{"m45pe10"},	{"m45pe80"},	{"m45pe16"},
 	{"m25pe20"},	{"m25pe80"},	{"m25pe16"},
 	{"m25px16"},	{"m25px32"},	{"m25px32-s0"},	{"m25px32-s1"},
-	{"m25px64"},
+	{"m25px64"},	{"m25px80"},
 	{"w25x10"},	{"w25x20"},	{"w25x40"},	{"w25x80"},
 	{"w25x16"},	{"w25x32"},	{"w25q32"},	{"w25q32dw"},
-	{"w25x64"},	{"w25q64"},	{"w25q128"},	{"w25q80"},
-	{"w25q80bl"},	{"w25q128"},	{"w25q256"},	{"cat25c11"},
+	{"w25x64"},	{"w25q64"},	{"w25q80"},	{"w25q80bl"},
+	{"w25q128"},	{"w25q256"},	{"cat25c11"},
 	{"cat25c03"},	{"cat25c09"},	{"cat25c17"},	{"cat25128"},
 	{ },
 };


