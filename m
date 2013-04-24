Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3DXLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:25:22 -0400
Received: from mx.mcc-med.de ([213.148.153.242]:37142 "EHLO mx.mcc-med.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab3DXLZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:25:21 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 07:25:21 EDT
From: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
To: "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Apr 2013 13:06:48 +0200
Subject: Atmel SPI master doesn't work in 3.9-rc8
Thread-Topic: Atmel SPI master doesn't work in 3.9-rc8
Thread-Index: Ac5A29DdpDgbk4xhScSJIGnoWspWOg==
Message-ID: <BAF0C2081321BA469F9ADF648F97D9B04D245702A0@MCC023.weinmann.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalRecipient: RPFD:nicolas.ferre@atmel.com
X-OriginalId: qfr3OB6npf020846
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

I just tried 3.9-rc8 with my board. SPI doesn't work, since in spi.c in __spi_async() was inserted new checking that initiate now xfer->speed_hz:
		if (!xfer->speed_hz)
			xfer->speed_hz = spi->max_speed_hz;


And in atmel-spi.c there are another checking that allows SPI work only for speed_hz == 0:

		/* FIXME implement these protocol options!! */
		if (xfer->speed_hz) {
			dev_dbg(&spi->dev, "no protocol options yet\n");
			return -ENOPROTOOPT;
		}


Best regards,
Sergey

