Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbaCVIjk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 22 Mar 2014 04:39:40 -0400
Received: from f224.i.mail.ru ([94.100.178.211]:47214 "EHLO f224.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaCVIjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 04:39:36 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U2FzaGEgTGV2aW4=?= <sasha.levin@oracle.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbXRkOiBkaXNrb25jaGlwOiBtZW0gcmVzb3VyY2UgbmFt?=
 =?UTF-8?B?ZSBpcyBub3Qgb3B0aW9uYWw=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 22 Mar 2014 12:39:32 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1395477572.57478225@f224.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1395267877-15223-1-git-send-email-sasha.levin@oracle.com>
References: <1395267877-15223-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s2M8ecKX014894

Wed, 19 Mar 2014 18:24:37 -0400 Ğ¾Ñ‚ Sasha Levin <sasha.levin@oracle.com>:
> Passing a name to request_mem_region() isn't optional and can't just
> be NULL. Passing NULL causes a NULL ptr deref later in the boot
> process.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/mtd/nand/diskonchip.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
> index b9b4db6..f68a7bc 100644
> --- a/drivers/mtd/nand/diskonchip.c
> +++ b/drivers/mtd/nand/diskonchip.c
> @@ -1439,7 +1439,7 @@ static int __init doc_probe(unsigned long physadr)
>  	int reg, len, numchips;
>  	int ret = 0;
>  
> -	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, NULL))
> +	if (!request_mem_region(physadr, DOC_IOREMAP_LEN, "DiskOnChip"))
>  		return -EBUSY;
>  	virtadr = ioremap(physadr, DOC_IOREMAP_LEN);
>  	if (!virtadr) {
> -- 

Tested-by: Alexander Shiyan <shc_work@mail.ru>

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
