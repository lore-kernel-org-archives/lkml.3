Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaE1Iqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:46:55 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40655 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbaE1Iqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:46:53 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Cody P Schafer'" <dev@codyps.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: RE: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
Thread-Topic: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
Thread-Index: AQHPehtRSTTppVgBd0OVC+FRTYrw6JtVrLPQ
Date: Wed, 28 May 2014 08:45:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724EEAF@AcuExch.aculab.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
 <1401236684-10579-12-git-send-email-dev@codyps.com>
In-Reply-To: <1401236684-10579-12-git-send-email-dev@codyps.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4S8l5Xw029308

From: Cody P Schafer
> Rather manually specifying the size of the integer to be converted, key
> off of the type size. Reduces duplicate size info and the occurance of
> certain types of bugs (using the wrong sized conversion).
...
> +#define be_to_cpu(v) \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
> +	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
> +		(void)0))))
...

I'm not at all sure that using the 'size' of the constant will reduce
the number of bugs - it just introduces a whole new category of bugs.

Using the size of the destination might help, but that makes the code
ugly.

Getting one of the static analysers to find the obvious errors is
probably more appropriate.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
