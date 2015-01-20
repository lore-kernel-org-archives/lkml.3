Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbbATKno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:43:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65457 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbbATKnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:43:42 -0500
Date: Tue, 20 Jan 2015 12:43:38 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: gregkh@linuxfoundation.org
Cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        mwelling@ieee.org, daniel.baluta@intel.com, aybuke.147@gmail.com,
        monamagarwal123@gmail.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: tsl2583: fix format string warnings
Message-ID: <20150120104338.GA17675@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings (reported by cppcheck):
[drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 2)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/light/tsl2583.c:695]: (warning) %d in format string (no. 3)
requires 'int' but the argument type is 'unsigned int'.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/staging/iio/light/tsl2583.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index cc4ddcc..8afae8e 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -692,7 +692,7 @@ static ssize_t taos_luxtable_show(struct device *dev,
 	int offset = 0;
 
 	for (i = 0; i < ARRAY_SIZE(taos_device_lux); i++) {
-		offset += sprintf(buf + offset, "%d,%d,%d,",
+		offset += sprintf(buf + offset, "%u,%u,%u,",
 				  taos_device_lux[i].ratio,
 				  taos_device_lux[i].ch0,
 				  taos_device_lux[i].ch1);
-- 
1.7.0.4

