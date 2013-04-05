Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123Ab3DEB4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:56:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46938 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab3DEB4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:56:24 -0400
X-AuditID: cbfee68e-b7f946d000001e37-4e-515e2f4767ba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01ce31a0$a9cc7400$fd655c00$%han@samsung.com>
In-reply-to: <000b01ce31a0$a9cc7400$fd655c00$%han@samsung.com>
Subject: [PATCH 3/3] misc: lattice-ecp3-config: use spi_get_drvdata()
Date: Fri, 05 Apr 2013 10:56:22 +0900
Message-id: <000d01ce31a0$c5ce40c0$516ac240$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xoKm1XjxbSUlOS4SxFc1W0tdNQgAABHrQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zA113/bhAg7fXWS2aF69ns7i88BKr
	xeVdc9gcmD32z13D7tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZrU3TGQs62SuuP1rL0sD4
	jbWLkZNDQsBE4uPUXiYIW0ziwr31bF2MXBxCAssYJZZfbmeGKTp/voMdIjGdUeLL4fWMEM4v
	RomrW5vBRrEJqEl8+XKYHcQWETCV2Ph+ClARBwezgIvE0WkiIGEhAVuJi9s/gJVwCthJ3Fn9
	lgmkRFjAVeLK3iiQMIuAqkTz3g9sIDYvUPnqOztZIGxBiR+T74HZzAJaEut3HmeCsOUlNq95
	ywwyRkJAXeLRX12IA4wkTv/5xQhRIiKx78U7sIslBPaxS7Ts+8MCsUtA4tvkQywQvbISmw5A
	vSspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SPz17WC8ecD6EGMy0PqJzFKiyfnA+M0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA+NK5iUlBhcmX1n4e2H12ar0/Qzaa+rXPWO47uzDvVE1Vf7m
	Y74TvCYX9usyPnwxJ6BGo0Bs4V2DazmuK8/mnFGY/jzxqgm3Lsf89YqtN8R1Qhimxsxd9V/U
	88X+J2ziwbFsP7S1igSqd1Uq7PrntfqNa0vcvimNX0NFi7dt/LtQumznO/snWs+UWIozEg21
	mIuKEwHfVnnx1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV13/bhAg6dzGC2aF69ns7i88BKr
	xeVdc9gcmD32z13D7tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGa1N0xkLOtkrrj9ay9LA+I21i5GTQ0LAROL8+Q52CFtM4sK99WxdjFwcQgLTGSW+
	HF7PCOH8YpS4urUZrINNQE3iy5fDYB0iAqYSG99PASri4GAWcJE4Ok0EJCwkYCtxcfsHsBJO
	ATuJO6vfMoGUCAu4SlzZGwUSZhFQlWje+4ENxOYFKl99ZycLhC0o8WPyPTCbWUBLYv3O40wQ
	trzE5jVvmUHGSAioSzz6qwtxgJHE6T+/GCFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH9zPpHYyrGiwOMQpwMCrx8Gb0xQYKsSaWFVfm
	HmKU4GBWEuHdyRcXKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wMSTVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MU4On/zqpUL5iQcjLvBitg32Sj86J
	L5fPn1HUIBIbOmXW/onX93jd3zEvt85dTlqgX/19xN2I6aXnK+IMbq5OLVNjefEkT+iL8PwT
	vJp2jjc5PF6c+bTxrltYYj+Hlr7Yf1v9hp+3v17dOGUJY4LGi5nrjy/On2pRz9SRdfrslpU+
	qx5P4ty7XYmlOCPRUIu5qDgRADwe87UyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/lattice-ecp3-config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 155700b..bb26f08 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -69,7 +69,7 @@ static const struct ecp3_dev ecp3_dev[] = {
 static void firmware_load(const struct firmware *fw, void *context)
 {
 	struct spi_device *spi = (struct spi_device *)context;
-	struct fpga_data *data = dev_get_drvdata(&spi->dev);
+	struct fpga_data *data = spi_get_drvdata(spi);
 	u8 *buffer;
 	int ret;
 	u8 txbuf[8];
-- 
1.7.2.5


