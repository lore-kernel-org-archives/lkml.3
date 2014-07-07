Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaGGXyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaGGXyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Kocialkowski <contact@paulk.fr>,
        Sebastian Reichel <sre@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 069/122] twl4030-madc: Request processed values in twl4030_get_madc_conversion
Date: Mon,  7 Jul 2014 16:57:11 -0700
Message-Id: <20140707235736.335390901@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <contact@paulk.fr>

commit e0326be0cded13dfc3a24cbeece1f1ae64348a0e upstream.

Not setting the raw parameter in the request causes it to be randomly
initialized to a value that might be different from zero or zero. This leads to
values that are randomly either raw or processed, making it very difficult to
make reliable use of the values.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/twl4030-madc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/twl4030-madc.c
+++ b/drivers/iio/adc/twl4030-madc.c
@@ -645,6 +645,7 @@ int twl4030_get_madc_conversion(int chan
 	req.channels = (1 << channel_no);
 	req.method = TWL4030_MADC_SW2;
 	req.active = 0;
+	req.raw = 0;
 	req.func_cb = NULL;
 	ret = twl4030_madc_conversion(&req);
 	if (ret < 0)


