Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaHESuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaHESOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 19/42] iio:bma180: Missing check for frequency fractional part
Date: Tue,  5 Aug 2014 11:13:33 -0700
Message-Id: <20140805181321.595412275@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Meerwald <pmeerw@pmeerw.net>

commit 9b2a4d35a6ceaf217be61ed8eb3c16986244f640 upstream.

val2 should be zero

This will make no difference for correct inputs but will reject
incorrect ones with a decimal part in the value written to the sysfs
interface.

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bma180.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -376,6 +376,8 @@ static int bma180_write_raw(struct iio_d
 		mutex_unlock(&data->mutex);
 		return ret;
 	case IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY:
+		if (val2)
+			return -EINVAL;
 		mutex_lock(&data->mutex);
 		ret = bma180_set_bw(data, val);
 		mutex_unlock(&data->mutex);


