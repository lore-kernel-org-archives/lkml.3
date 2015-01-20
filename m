Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbbATHZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:25:33 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45634 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbbATHZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:25:26 -0500
Date: Tue, 20 Jan 2015 09:25:22 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: gregkh@linuxfoundation.org
Cc: lars@metafoo.de, Michael.Hennerich@analog.com, jic23@kernel.org,
        knaack.h@gmx.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: ad5933: fix format string warnings
Message-ID: <20150120072522.GA3361@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings (reported by cppcheck):
[drivers/staging/iio/impedance-analyzer/ad5933.c:363]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 1)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 2)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 3)
requires 'int' but the argument type is 'unsigned int'.
[drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 4)
requires 'int' but the argument type is 'unsigned int'.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index b6bd609..4230a43 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -360,11 +360,11 @@ static ssize_t ad5933_show(struct device *dev,
 	mutex_lock(&indio_dev->mlock);
 	switch ((u32) this_attr->address) {
 	case AD5933_OUT_RANGE:
-		len = sprintf(buf, "%d\n",
+		len = sprintf(buf, "%u\n",
 			      st->range_avail[(st->ctrl_hb >> 1) & 0x3]);
 		break;
 	case AD5933_OUT_RANGE_AVAIL:
-		len = sprintf(buf, "%d %d %d %d\n", st->range_avail[0],
+		len = sprintf(buf, "%u %u %u %u\n", st->range_avail[0],
 			      st->range_avail[3], st->range_avail[2],
 			      st->range_avail[1]);
 		break;
-- 
1.7.0.4

