Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbaD3LAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:00:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48489 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509AbaD3LAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:00:18 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>
Subject: RE: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH
 Controller
Thread-Topic: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH
 Controller
Thread-Index: AQHPSAMZxGz7oQGsEk27seq0WSyPipry1aNAgDb6YgCAAGRNsA==
Date: Wed, 30 Apr 2014 10:59:33 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAC6A35@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-8-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5CB7@DBDE04.ent.ti.com>
 <20140430102244.GK29462@lee--X1>
In-Reply-To: <20140430102244.GK29462@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3UB0QG4006851

>From: Lee Jones [mailto:lee.jones@linaro.org]
>>On Wed, 26 Mar 2014, Gupta, Pekon wrote:
[...]

>> >+	/* Reset and disable boot-mode controller */
>> >+	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
>> >+	udelay(1);
>> >+	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);
>>
>> Why using 'udelay' ?
>> Isn't there any status register which tells you that controller is reset / initialized ?
>> Or may be polling on NANDBCH_BOOTBANK_CFG may itself give you status.
>
>Documenation says:
>
>  "The soft reset bit has to be reset to â€˜0â€™ to de-assert the soft
>   reset. The soft reset bit is expected to be asserted for at least
>   one clock cycle for proper reset"
>
Thatâ€™s the hardware way of saying that 'enable the clock before applying reset'.
Clock is required to propagate reset-logic to flip-flops in pipeline, which do not get direct reset.

However that apart. You may safely drop udelay(1) because this 'udelay' is at
CPU side and won't guarantee anything about clocks at your controller side.
But I leave it to you as this delay is pretty small.


with regards, pekon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
