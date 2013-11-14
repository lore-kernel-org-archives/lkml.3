Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3KNPVl (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Nov 2013 10:21:41 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:52479 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3KNPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:21:33 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWFyayBSdXRsYW5k?= <mark.rutland@arm.com>
Cc: =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        =?UTF-8?B?ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc=?= 
	<devicetree@vger.kernel.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        =?UTF-8?B?Z3JhbnQubGlrZWx5QGxpbmFyby5vcmc=?= 
	<grant.likely@linaro.org>,
        =?UTF-8?B?cm9iLmhlcnJpbmdAY2FseGVkYS5jb20=?= 
	<rob.herring@calxeda.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbWZkOiBzeXNjb246IEFsbG93IHRvIHVzaW5nIHN1YmRl?=
 =?UTF-8?B?dmljZXM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Thu, 14 Nov 2013 18:58:46 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1384441126.564885163@f359.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131114144559.GC28328@e106331-lin.cambridge.arm.com>
References: <1384433523-30602-1-git-send-email-shc_work@mail.ru>
 <20131114144559.GC28328@e106331-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id rAEFLmDm030093

Hello.

> On Thu, Nov 14, 2013 at 12:52:03PM +0000, Alexander Shiyan wrote:
> > This patch adds support for using subdevices within syscon node.
> > Primary usage of this is describe all devices with same memory
> > region in one container.
> 
> I think if you need to do this, you should not be using syscon. What
> exactly is your use-case?
> 
> I don't like the idea of treating syscon like a bus or container in this
> fashion.

Let me first show the new syscon-based driver. After a while, I'm going
to provide it. It will use the current way of getting syscon, i.e. through
syscon_regmap_lookup_by_phandle().

> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/mfd/syscon.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> > index 71841f9..6e9244a 100644
> > --- a/drivers/mfd/syscon.c
> > +++ b/drivers/mfd/syscon.c
> > @@ -152,6 +152,9 @@ static int syscon_probe(struct platform_device *pdev)
> >  
> >  	platform_set_drvdata(pdev, syscon);
> >  
> > +	if (of_platform_populate(dev->of_node, NULL, NULL, dev))
> > +		dev_warn(dev, "Fail to create subdevices\n");
> > +
> >  	dev_info(dev, "regmap %pR registered\n", res);
> >  
> >  	return 0;
> > -- 

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
