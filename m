Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaBGNeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:34:46 -0500
Received: from mx0.aculab.com ([213.249.233.131]:32808 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752162AbaBGNeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:34:44 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 19/26] drivers: isdn: Move prototype declaration to
 header file platform.h from diva_didd.c
Thread-Topic: [PATCH 19/26] drivers: isdn: Move prototype declaration to
 header file platform.h from diva_didd.c
Thread-Index: AQHPJAIZEAfhJt2pSki9/NC6TGJzyJqpydjw
Date: Fri, 7 Feb 2014 13:33:46 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BA76D@AcuExch.aculab.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
 <93d7188538418423685ecefaf3d2bb311b37be6e.1390408518.git.rashika.kheria@gmail.com>
In-Reply-To: <93d7188538418423685ecefaf3d2bb311b37be6e.1390408518.git.rashika.kheria@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s17DYtYh015419

From: Rashika Kheria
> Move prototype declarations of function to header file
> hardware/eicon/platform.h because they are used by more than one file.
> 
> This eliminates the following warnings in hardware/eicon/diddfunc.c:
> drivers/isdn/hardware/eicon/diddfunc.c:95:12: warning: no previous prototype for diddfunc_init [-
> Wmissing-prototypes]
> drivers/isdn/hardware/eicon/diddfunc.c:110:13: warning: no previous prototype for diddfunc_finit [-
> Wmissing-prototypes]
...
> diff --git a/drivers/isdn/hardware/eicon/diva_didd.c b/drivers/isdn/hardware/eicon/diva_didd.c
> index fab6ccf..56d32a7 100644
> --- a/drivers/isdn/hardware/eicon/diva_didd.c
> +++ b/drivers/isdn/hardware/eicon/diva_didd.c
> @@ -39,9 +39,6 @@ MODULE_LICENSE("GPL");
>  #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
>  #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
> 
> -extern int diddfunc_init(void);
> -extern void diddfunc_finit(void);
> -
>  extern void DIVA_DIDD_Read(void *, int);

You should move that one as well.
There really shouldn't be 'extern' definitions for any function in
any C files since you want the compiler to check they are correct
when the function itself is compiled.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
