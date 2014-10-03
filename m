Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaJCWnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:43:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbaJCWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 079/143] iio: gyro: itg3200: Fix indio_dev->trig assignment
Date: Fri,  3 Oct 2014 14:34:34 -0700
Message-Id: <20141003213316.881245762@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 0b4dce2ee694a991ef38203ec5ff91a738518cb3 upstream.

This can result in wrong reference count for trigger device, call
iio_trigger_get to increment reference.
Refer to http://www.spinics.net/lists/linux-iio/msg13669.html for discussion
with Jonathan.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/gyro/itg3200_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -135,7 +135,7 @@ int itg3200_probe_trigger(struct iio_dev
 		goto error_free_irq;
 
 	/* select default trigger */
-	indio_dev->trig = st->trig;
+	indio_dev->trig = iio_trigger_get(st->trig);
 
 	return 0;
 


