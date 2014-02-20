Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaBTXyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:54:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaBTXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:54:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.13 51/99] staging:iio:impedance:ad5933: correct error check
Date: Thu, 20 Feb 2014 15:52:46 -0800
Message-Id: <20140220235119.687119266@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@lip6.fr>

commit e9ed104de68c345c9a827225e93c74c6894613a9 upstream.

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
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -629,7 +629,7 @@ static int ad5933_register_ring_funcs_an
 	struct iio_buffer *buffer;
 
 	buffer = iio_kfifo_allocate(indio_dev);
-	if (buffer)
+	if (!buffer)
 		return -ENOMEM;
 
 	iio_device_attach_buffer(indio_dev, buffer);


