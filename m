Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaE0DM3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 26 May 2014 23:12:29 -0400
Received: from f271.i.mail.ru ([94.100.185.87]:32865 "EHLO f271.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaE0DM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:12:27 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QWxleGFuZGVyIEhvbGxlcg==?= <holler@ahsoftware.de>
Cc: =?UTF-8?B?RGF2aWQgV29vZGhvdXNl?= <dwmw2@infradead.org>,
        =?UTF-8?B?QnJpYW4gTm9ycmlz?= <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwOS8yN10gbXRkOiBuYW5kOiBweGEzeHg6IHNob3cgZGV2?=
 =?UTF-8?B?aWNlIHN0cnVjdHVyZSBpbiBzeXNmcw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Tue, 27 May 2014 07:12:21 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1401160341.192042842@f271.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s4R3CfnR011733

Tue, 27 May 2014 00:12:34 +0200 Ğ¾Ñ‚ Alexander Holler <holler@ahsoftware.de>:
> Fix a common error in nand-drivers which do not set up a parent device for
> the mtd-device by using a new inline function.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  drivers/mtd/nand/pxa3xx_nand.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 7588fe2..7f62e7c 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -1584,8 +1584,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
>  		host->mtd = mtd;
>  		host->cs = cs;
>  		host->info_data = info;
> -		mtd->priv = host;
> -		mtd->owner = THIS_MODULE;
> +		mtd_setup_common_members(mtd, host, pdev);
>  
>  		chip->ecc.read_page	= pxa3xx_nand_read_page_hwecc;
>  		chip->ecc.write_page	= pxa3xx_nand_write_page_hwecc;
> -- 

Should we add "driver.owner = THIS_MODULE" field for struct platform_driver in this case?

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
