Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3H1Kbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:31:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:42493 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3H1Kbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:31:37 -0400
Date: Wed, 28 Aug 2013 12:31:34 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] iio: am335x-iio-adc: select triggered buffer
Message-ID: <20130828103134.GA14111@linutronix.de>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"triggered buffer" isn't selected so we end up with:
|ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/ti_am335x_adc.ko] undefined!

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Please merge this into _this_ patch, it is still required.

 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 09371cb..cfa2039 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -167,6 +167,7 @@ config TI_ADC081C
 config TI_AM335X_ADC
 	tristate "TI's AM335X ADC driver"
 	depends on MFD_TI_AM335X_TSCADC
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Texas Instruments ADC
 	  driver which is also a MFD client.
-- 
1.8.4.rc3

