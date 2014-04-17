Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161485AbaDQKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:12:00 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:38290 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161002AbaDQKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:11:56 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Sm9oYW5uZXMgVGh1bXNoaXJu?= <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        =?UTF-8?B?VGhvbWFzIFNjaG51ZXJlcg==?= <thomas.schnuerer@men.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?SmlyaSBTbGFieQ==?= <jslaby@suse.cz>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gdHR5OiBzZXJpYWw6IEFkZCBkcml2ZXIgZm9yIE1FTidz?=
 =?UTF-8?B?IDE2ejEzNSBIaWdoIFNwZWVkIFVBUlQu?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Thu, 17 Apr 2014 14:08:28 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1397729308.556196520@f417.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1397727894-10123-1-git-send-email-johannes.thumshirn@men.de>
References: <1397727894-10123-1-git-send-email-johannes.thumshirn@men.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3HACFs5012180

Thu, 17 Apr 2014 11:44:54 +0200 Ğ¾Ñ‚ Johannes Thumshirn <johannes.thumshirn@men.de>:
> Add driver for MEN's 16z135 High Speed UART.
> 
> The 16z135 is a memory mapped UART Core on an MCB FPGA and has 1024 byte
> deep FIFO buffers for the RX and TX path. It also has configurable FIFO
> fill level IRQs and data copied to and from the hardware has to be
> acknowledged.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
...
> +static int men_z135_probe(struct mcb_device *mdev,
> +			const struct mcb_device_id *id)
> +{
> +	struct men_z135_port *uart;
> +	struct resource *mem;
> +	struct device *dev;
> +	int err;
> +
> +	dev = &mdev->dev;
> +
> +	uart = devm_kzalloc(dev, sizeof(struct men_z135_port), GFP_KERNEL);
> +	if (!uart)
> +		return -ENOMEM;
> +
> +	uart->rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
> +	if (!uart->rxbuf)
> +		return -ENOMEM;
> +
> +	mem = &mdev->mem;
> +
> +	mcb_set_drvdata(mdev, uart);
> +
> +	uart->port.uartclk = MEN_Z135_BASECLK * 16;
> +	uart->port.fifosize = MEN_Z135_FIFO_SIZE;
> +	uart->port.iotype = UPIO_MEM;
> +	uart->port.ops = &men_z135_ops;
> +	uart->port.irq = mcb_get_irq(mdev);
> +	uart->port.iotype = UPIO_MEM;
> +	uart->port.flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP;
> +	uart->port.line = line++;

So, every time a module is loaded/unloaded and loaded again,
you increase the line number?

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
