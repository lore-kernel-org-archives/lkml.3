Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaEIKcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:32:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51098 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaEIKcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:32:45 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: RE: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree support
Thread-Topic: [RFC 13/47] mtd: nand: stm_nand_bch: provide Device Tree
 support
Thread-Index: AQHPSAMgB9WSu3WEI0qVLuMmzpyAn5rzCprAgDbvtgCAB81FEIAGJ+0AgABipVA=
Date: Fri, 9 May 2014 10:32:02 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EACBC8F@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-14-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5C83@DBDE04.ent.ti.com>
 <20140430125406.GN29462@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EACA3F0@DBDE04.ent.ti.com>
 <20140509100304.GR5767@lee--X1>
In-Reply-To: <20140509100304.GR5767@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s49AWqVr002220

>From: Lee Jones [mailto:lee.jones@linaro.org]
>
>> >> >+	of_property_read_u32(np, "st,bch-bitflip-threshold",
>> >> >+			     &pdata->bch_bitflip_threshold);
>> >> >+
>> >> mtd->bitflip_threshold is by default set to ecc.strength (unless a driver initializes it).
>> >> And then can be re-configured for each MTD partition separately
>> >> 	/sys/class/mtd/mtdX/bitflip_threshold
>> >> 	Refer: $kernel/Documentation/ABI/testing/sysfs-class-mtd
>> >> So, I don't think this is a HW parameter, and so should not be passed from DT.
>> >
>> >I think the bit-flip threshold is/can be chip specific, and as we know
>> >which chip we're likely to be booting on, we can specify this via the
>> >hardware description.  Thus, I think it's perfectly viable for an
>> >option to pass through DT to exist.
>> >
>> I don't think thatâ€™s the correct interpretation of bitflip_threshold.
>>
>> (1) bitflip_threshold is dependent on ecc.strength (ECC scheme) of your driver.
>> MTD layers uses bitflip_threshold to warn above layers that number of
>> correctable bit-flips have reached a dangerous level beyond which driver's
>> ECC scheme may not be able to correct them. So above layers should start
>> taking additional corrective action like scrubbing.
>> 	@@drivers/mtd/mtdcore.c: mtd_read()
>> 		return ret_code >= mtd->bitflip_threshold ? -EUCLEAN : 0;
>>
>> (2) Also, user-space may control it based on how your device ages on field.
>> A fresh silicon may not show too many bitflips. But as device ages the
>> probability of simultaneous bitflips will increase. So user-space may lower
>> the bitflip_threshold to avoid accumulation of bitflips in a single page.
>>
>> Thus, bitflip_threshold should not be passed via DT.
>> It's neither a hardware parameter, nor itâ€™s a static constant.
>
>Ah, I see.  I will fixup, thanks for the explanation.
>

Please wait, I'll review your [v2] series also, then you can further
send all fixes together. I'm bit caught in other commitments for 3.16,
so hopefully I'll be able to review your patches by next week.


with regards, pekon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
