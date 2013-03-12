Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3CLBMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:12:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35676 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3CLBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:12:20 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 12/16] spi/spi-atmel: add pinctrl support for atmel
 spi
Thread-Topic: [PATCH v6 12/16] spi/spi-atmel: add pinctrl support for atmel
 spi
Thread-Index: AQHOGuT5pfFogj1hcEeIUhoDOmw0Y5if9/gAgAFOnuA=
Date: Tue, 12 Mar 2013 01:10:15 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436414972659B@penmbx02>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
 <1362627243-9351-1-git-send-email-wenyou.yang@atmel.com>
 <20130311131126.GB2001@game.jcrosoft.org>
In-Reply-To: <20130311131126.GB2001@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2C1COFM012043

Hi JC,

> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: 2013Äê3ÔÂ11ÈÕ 21:11
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca; Ferre,
> Nicolas; richard.genoud@gmail.com; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 12/16] spi/spi-atmel: add pinctrl support for atmel spi
> 
> On 11:34 Thu 07 Mar     , Wenyou Yang wrote:
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: spi-devel-general@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/spi/spi-atmel.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> > index 1e212d1..6b166f4 100644
> > --- a/drivers/spi/spi-atmel.c
> > +++ b/drivers/spi/spi-atmel.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/platform_data/atmel.h>
> >  #include <linux/platform_data/dma-atmel.h>
> >  #include <linux/of.h>
> > +#include <linux/pinctrl/consumer.h>
> >
> >  #include <linux/io.h>
> >  #include <linux/gpio.h>
> > @@ -1493,11 +1494,18 @@ static int atmel_spi_probe(struct
> platform_device *pdev)
> >  	int			ret;
> >  	struct spi_master	*master;
> >  	struct atmel_spi	*as;
> > +	struct pinctrl		*pinctrl;
> >
> >  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (!regs)
> >  		return -ENXIO;
> >
> > +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> > +	if (IS_ERR(pinctrl)) {
> > +		dev_err(&pdev->dev, "Failed to request pinctrl\n");
> > +		return PTR_ERR(pinctrl);
> > +	}
> 
> drop this, this is handled at bus level
> 
Thanks a lot for your advance.

> Best Regards,
> J.

Best Regards
Wenyou Yang
> > +
> >  	irq = platform_get_irq(pdev, 0);
> >  	if (irq < 0)
> >  		return irq;
> > --
> > 1.7.9.5
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
