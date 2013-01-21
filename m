Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3AUVLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:11:02 -0500
Received: from mout.gmx.net ([212.227.17.20]:53373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab3AUVLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:11:00 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18og4hBqcUom87KWLuX2rcSMq6x7fTgPXZ2C1hEhb
	UzrOAsOr+Pa6sK
From: Peter Huewe <peterhuewe@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/iio: Use correct argument for sizeof
Date: Mon, 21 Jan 2013 22:14:02 +0100
Message-Id: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found with coccicheck
sizeof when applied to a pointer typed expression gives the size of
the pointer

The semantic patch that makes this output is available
in scripts/coccinelle/misc/noderef.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/iio/iio_hwmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/iio_hwmon.c b/drivers/staging/iio/iio_hwmon.c
index c7a5f97..97ad645 100644
--- a/drivers/staging/iio/iio_hwmon.c
+++ b/drivers/staging/iio/iio_hwmon.c
@@ -93,7 +93,7 @@ static int iio_hwmon_probe(struct platform_device *pdev)
 	while (st->channels[st->num_channels].indio_dev)
 		st->num_channels++;
 
-	st->attrs = kzalloc(sizeof(st->attrs) * (st->num_channels + 1),
+	st->attrs = kzalloc(sizeof(*st->attrs) * (st->num_channels + 1),
 			    GFP_KERNEL);
 	if (st->attrs == NULL) {
 		ret = -ENOMEM;
-- 
1.7.8.6

