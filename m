Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaCDJXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:23:25 -0500
Received: from f148.i.mail.ru ([94.100.178.199]:46096 "EHLO f148.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbaCDJXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:23:23 -0500
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 04:23:22 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGV0ZXIgVWpmYWx1c2k=?= <peter.ujfalusi@ti.com>
Cc: =?UTF-8?B?U2FudG9zaCBTaGlsaW1rYXI=?= <santosh.shilimkar@ti.com>,
        =?UTF-8?B?VG9ueSBMaW5kZ3Jlbg==?= <tony@atomide.com>,
        =?UTF-8?B?T2xvZiBKb2hhbnNzb24=?= <olof@lixom.net>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzVdIGRyaXZlcnM6IGJ1czogb21hcF9sMzogQ29udmVy?=
 =?UTF-8?B?dCB0byB1c2UgZGV2bV9yZXF1ZXN0X2FuZF9pb3JlbWFwKCk=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 04 Mar 2014 13:23:20 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1393925000.716948505@f148.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1393924359.866301359@f148.i.mail.ru>
References: <1393923710-10377-1-git-send-email-peter.ujfalusi@ti.com>
 <1393923710-10377-3-git-send-email-peter.ujfalusi@ti.com>
 <1393924359.866301359@f148.i.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s249NXpN002313

Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº,  4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 13:12 +04:00 Ğ¾Ñ‚ Alexander Shiyan <shc_work@mail.ru>:
> Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº,  4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 11:01 +02:00 Ğ¾Ñ‚ Peter Ujfalusi <peter.ujfalusi@ti.com>:
> > We can then remove the iounmap() calls from probe and remove.
> > Since the driver requests the resources via index we can do the mem resource
> > request within a for loop.
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti>
> > ---
> 
> > +	/* Get mem resources */
> > +	for (i = 0; i < 3; i++) {
> > +		struct resource	*res = platform_get_resource(pdev,
> > +							     IORESOURCE_MEM, i);
> > +		if (!res) {
> > +			dev_err(&pdev->dev, "couldn't find resource %d\n", i);
> > +			return -ENODEV;
> > +		}
> 
> No need to check "res". devm_request_and_ioremap() do all for us.
> 
> > -	l3->l3_base[2] = ioremap(res->start, resource_size(res));
> > -	if (!l3->l3_base[2]) {
> > -		dev_err(&pdev->dev, "ioremap failed\n");
> > -		ret = -ENOMEM;
> > -		goto err2;
> > +		l3->l3_base[i] = devm_request_and_ioremap(&pdev->dev, res);
> > +		if (!l3->l3_base[i]) {
> 
> if (IS_ERR(l3->l3_base[i]))

Ahh, I messed up this with devm_ioremap_resource().
However, if there is reason to use devm_request_and_ioremap() here?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
