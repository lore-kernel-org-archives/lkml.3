Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3B0F4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:56:38 -0500
Received: from intranet.asianux.com ([58.214.24.6]:54799 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3B0F4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:56:37 -0500
X-Spam-Score: -100.8
Message-ID: <512DA000.2060608@asianux.com>
Date: Wed, 27 Feb 2013 13:56:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/misc: beautify code: chip->lux_calib is u16 which
 will never more than APDS_RANGE
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  APDS_RANGE is 65535, chip->lux_calib is u16 (never more than APDS_RANGE).

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/misc/apds990x.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 0e67f82..1efb6a4 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -700,9 +700,6 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
 	if (strict_strtoul(buf, 0, &value))
 		return -EINVAL;
 
-	if (chip->lux_calib > APDS_RANGE)
-		return -EINVAL;
-
 	chip->lux_calib = value;
 
 	return len;
-- 
1.7.7.6
