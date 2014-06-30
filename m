Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaF3GpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:45:14 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:34912 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaF3GpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:45:09 -0400
Date: Mon, 30 Jun 2014 09:45:04 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: ismael.luceno@corp.bluecherry.net
Cc: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH next-20140627] drivers/staging/media/solo6x10: sparse warning
 corrections
Message-ID: <20140630064503.GA32377@outside>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning correction:
  CHECK   drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
drivers/staging/media/solo6x10/solo6x10-jpeg.h:113:21: warning: symbol 'jpeg_dqt
' was not declared. Should it be static?

The symbol jpeg_dqt is used just in solo6x10-v4l2-enc.c, so I think it
makes sense to declare it static, which suppresses the sparse warning.

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/staging/me
index c5218ce..9e41185 100644
--- a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
+++ b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
@@ -110,7 +110,7 @@ static const unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of the DQT */
 #define DQT_START      17
 #define DQT_LEN                138
-const unsigned char jpeg_dqt[4][DQT_LEN] = {
+static const unsigned char jpeg_dqt[4][DQT_LEN] = {
        {
                0xff, 0xdb, 0x00, 0x43, 0x00,
                0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
