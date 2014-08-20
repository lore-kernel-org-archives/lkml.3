Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaHTMJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:09:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58891 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/104] iio:bma180: Missing check for frequency fractional part
Date: Wed, 20 Aug 2014 13:42:36 +0200
Message-Id: <e167bebf57cd9033574ee7f78f54e76fe1529e77.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b2a4d35a6ceaf217be61ed8eb3c16986244f640 upstream.

val2 should be zero

This will make no difference for correct inputs but will reject
incorrect ones with a decimal part in the value written to the sysfs
interface.

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/accel/bma180.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 225aea63eaf5..60a3bab42263 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -376,6 +376,8 @@ static int bma180_write_raw(struct iio_dev *indio_dev,
 		mutex_unlock(&data->mutex);
 		return ret;
 	case IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY:
+		if (val2)
+			return -EINVAL;
 		mutex_lock(&data->mutex);
 		ret = bma180_set_bw(data, val);
 		mutex_unlock(&data->mutex);
-- 
2.0.4

