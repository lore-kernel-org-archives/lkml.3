Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaAAMLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:11:20 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:29395
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbaAAMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.95,585,1384297200"; 
   d="scan'208";a="43157648"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:iio: correct error check
Date: Wed,  1 Jan 2014 14:07:21 +0100
Message-Id: <1388581641-26782-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

iio_kfifo_allocate returns NULL in case of error.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
identifier f;
statement S1,S2;
@@

*x = f(...);
 if (x) { <+... when != if (...) S1 else S2
     -ENOMEM ...+> }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index 0a4298b..2b96665 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -629,7 +629,7 @@ static int ad5933_register_ring_funcs_and_init(struct iio_dev *indio_dev)
 	struct iio_buffer *buffer;
 
 	buffer = iio_kfifo_allocate(indio_dev);
-	if (buffer)
+	if (!buffer)
 		return -ENOMEM;
 
 	iio_device_attach_buffer(indio_dev, buffer);

