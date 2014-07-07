Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaGGOJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:09:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:53967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaGGOJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="558335323"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, pmeerw@pmeerw.net
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Daniel Baluta <daniel.baluta@intel.com>
Subject: [PATCH] staging: iio: remove duplicate case labels
Date: Mon,  7 Jul 2014 17:12:13 +0300
Message-Id: <1404742333-22681-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, compiling iio_event_monitor program fails:

io_event_monitor.c: In function ‘event_is_known’:
iio_event_monitor.c:125:2: error: duplicate case value
  case IIO_MOD_LIGHT_BOTH:
  ^
iio_event_monitor.c:121:2: error: previously used here
  case IIO_MOD_LIGHT_BOTH:

Fixes: da4db94 (iio staging: add recently added modifiers to iio_event_monitor)
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/staging/iio/Documentation/iio_event_monitor.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
index cb35a97..569d6f8 100644
--- a/drivers/staging/iio/Documentation/iio_event_monitor.c
+++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
@@ -122,8 +122,6 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_MOD_LIGHT_IR:
 	case IIO_MOD_ROOT_SUM_SQUARED_X_Y:
 	case IIO_MOD_SUM_SQUARED_X_Y_Z:
-	case IIO_MOD_LIGHT_BOTH:
-	case IIO_MOD_LIGHT_IR:
 	case IIO_MOD_LIGHT_CLEAR:
 	case IIO_MOD_LIGHT_RED:
 	case IIO_MOD_LIGHT_GREEN:
-- 
1.9.1

