Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab3FMPvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:51:40 -0400
Received: from mxout1.idt.com ([157.165.5.25]:48112 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab3FMPvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:51:39 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RAPIDIO: Fix idt_gen2.c build
Thread-Topic: [PATCH] RAPIDIO: Fix idt_gen2.c build
Thread-Index: AQHOaE0Shbtjgbiyn0epBaetwfLi2pkzyu8w
Date: Thu, 13 Jun 2013 15:51:19 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC37BC9@corpmail1.na.ads.idt.com>
References: <20130613154231.GA27745@linux-mips.org>
In-Reply-To: <20130613154231.GA27745@linux-mips.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.29]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5DFpkPH030593

Looks good to me.

> -----Original Message-----
> From: Ralf Baechle [mailto:ralf@linux-mips.org]
> Sent: Thursday, June 13, 2013 11:43 AM
> To: Matt Porter; Bounine, Alexandre; linux-kernel@vger.kernel.org
> Subject: [PATCH] RAPIDIO: Fix idt_gen2.c build
> 
> idt_gen2.c relies that one of the header files used will include
> <asm/page.h> which will define the required symbol PAGE_SIZE.  On MIPS
> for example <asm/page.h> will not be included implicitly which will
> result in the following build error:
> 
>   CC      drivers/rapidio/switches/idt_gen2.o
> drivers/rapidio/switches/idt_gen2.c: In function â€˜idtg2_show_errlogâ€™:
> drivers/rapidio/switches/idt_gen2.c:379:30: error: â€˜PAGE_SIZEâ€™
> undeclared (first use in this function)
> drivers/rapidio/switches/idt_gen2.c:379:30: note: each undeclared
> identifier is reported only once for each function it appears in
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> ---
> 
> If you're ok with this patch I can put it into my next pull request for
> Linux.  Thanks!
> 
> 
>  drivers/rapidio/switches/idt_gen2.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/rapidio/switches/idt_gen2.c
> b/drivers/rapidio/switches/idt_gen2.c
> index 809b7a3..5d3b0f0 100644
> --- a/drivers/rapidio/switches/idt_gen2.c
> +++ b/drivers/rapidio/switches/idt_gen2.c
> @@ -15,6 +15,8 @@
>  #include <linux/rio_drv.h>
>  #include <linux/rio_ids.h>
>  #include <linux/delay.h>
> +
> +#include <asm/page.h>
>  #include "../rio.h"
> 
>  #define LOCAL_RTE_CONF_DESTID_SEL	0x010070
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
