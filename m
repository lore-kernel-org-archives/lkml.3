Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527Ab3EBRVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:21:35 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:46641 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761108Ab3EBRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:21:31 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?RmFiaW8gRXN0ZXZhbQ==?= <fabio.estevam@freescale.com>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?TWF1cm8gQ2FydmFsaG8gQ2hlaGFi?= <mchehab@redhat.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCwgUkZDIDIwLzIyXSBtZWRpYTogY29kYTogc2VsZWN0IEdF?=
 =?UTF-8?B?TkVSSUNfQUxMT0NBVE9S?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Thu, 02 May 2013 21:20:55 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1367515255.447627800@f375.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <1367507786-505303-21-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-21-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r42HMLwm005649

> The coda driver uses the generic allocator to get at the
> "iram" memory, so add the necessary dependency to avoid:
> 
> drivers/built-in.o: In function `coda_remove':
>  :(.text+0x2ab680): undefined reference to `gen_pool_free'
> drivers/built-in.o: In function `coda_probe':
> :(.text+0x2ad168): undefined reference to `of_get_named_gen_pool'
> :(.text+0x2ad188): undefined reference to `dev_get_gen_pool'
> :(.text+0x2ad220): undefined reference to `gen_pool_alloc'
> :(.text+0x2ad2ec): undefined reference to `gen_pool_virt_to_phys'
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 0494d27..4608d03 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -145,6 +145,7 @@ config VIDEO_CODA
>  	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
> +	select GENERIC_ALLOCATOR
>  	---help---
>  	   Coda is a range of video codec IPs that supports
>  	   H.264, MPEG-4, and other video formats.

Again?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
