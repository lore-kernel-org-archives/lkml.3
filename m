Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3JVTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:48:51 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:42139 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3JVTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:48:48 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RGF2aWQgQ29oZW4=?= <david.a.cohen@linux.intel.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, ning.li@intel.com,
        ivan.gorinov@intel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzJdIG1yc3RfbWF4MzExMDogZml4IFNQSSBVQVJUIGlu?=
 =?UTF-8?B?dGVycnVwdCBwYXJhbWV0ZXJz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Tue, 22 Oct 2013 23:46:00 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1382471160.205404749@f402.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1382470930-13807-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
 <1382470930-13807-2-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9MJmwgD008273

> The change in the max3110 driver makes the IRQ handling threaded, now
> the handler is called only once per received character. Without that
> change, we had many (more than 100) interrupts per one received
> character.
> 
> Unfortunately, SFI interface does not support IRQ polarity and
> triggering modes, so we have to keep the hacks as hard-coded device
> names and IRQ numbers until we switch to ACPI.
> 
> Edge-triggered IRQ still supported to keep old platforms working.
> Use platform data to pass the irq mode argument.
> 
> Signed-off-by: Ivan Gorinov <ivan.gorinov@intel.com>
> Signed-off-by: Li Ning <ning.li@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
...
> +++ b/include/linux/serial_max3110.h
> @@ -0,0 +1,16 @@
> +#ifndef _LINUX_SERIAL_MAX3110_H
> +#define _LINUX_SERIAL_MAX3110_H
> +
> +/**
> + * struct plat_max3110 - MAX3110 SPI UART platform data
> + * @irq_edge_trigger: if IRQ is edge triggered
> + *
> + * You should use this structure in your machine description to specify
> + * how the MAX3110 is connected.
> + *
> + */
> +struct plat_max3110 {
> +	int irq_edge_triggered;
> +};
> +
> +#endif
> -- 

Is just resource->flags for IRQ can be reused for handle such case?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
