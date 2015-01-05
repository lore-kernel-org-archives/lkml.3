Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbAENt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:49:29 -0500
Received: from h1.radempa.de ([176.9.142.194]:43430 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbbAENt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:49:28 -0500
From: Harald Geyer <harald@ccbib.org>
To: Jonathan Cameron <jic23@kernel.org>
cc: Richard Weinberger <richard@nod.at>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/3] iio: dht11: Fix out-of-bounds read
In-reply-to: <54A91DA1.6080107@kernel.org>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org>
Comments: In-reply-to Jonathan Cameron <jic23@kernel.org>
   message dated "Sun, 04 Jan 2015 11:01:53 +0000."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4823.1420465745.1@stardust.g4.wien.funkfeuer.at>
Date: Mon, 05 Jan 2015 14:49:05 +0100
Message-Id: <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we access i-1 we must not start with i=0.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Acked-by: Harald Geyer <harald@ccbib.org>
---
Resending for Richard Weinberger.
No changes since v1 except reordering.

 drivers/iio/humidity/dht11.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
index 623c145..f546eca 100644
--- a/drivers/iio/humidity/dht11.c
+++ b/drivers/iio/humidity/dht11.c
@@ -88,7 +88,7 @@ static int dht11_decode(struct dht11 *dht11, int offset)
 	unsigned char temp_int, temp_dec, hum_int, hum_dec, checksum;
 
 	/* Calculate timestamp resolution */
-	for (i = 0; i < dht11->num_edges; ++i) {
+	for (i = 1; i < dht11->num_edges; ++i) {
 		t = dht11->edges[i].ts - dht11->edges[i-1].ts;
 		if (t > 0 && t < timeres)
 			timeres = t;
-- 
1.7.2.5

