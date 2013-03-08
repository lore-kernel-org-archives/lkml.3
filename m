Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3CHBG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:06:27 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:40119 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752543Ab3CHBGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:06:25 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Joachim Eastwood <manabian@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Topic: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Index: AQHOGuP8IM96tyzK7E6aJ9clb/yCNJiZo0mAgAFXq6A=
Date: Fri, 8 Mar 2013 01:06:11 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436414971BE26@penmbx02>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
	<1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
 <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com>
In-Reply-To: <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2816RRU025470

Hi Joachim,

> -----Original Message-----
> From: Joachim Eastwood [mailto:manabian@gmail.com]
> Sent: 2013Äê3ÔÂ7ÈÕ 20:31
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca; Ferre,
> Nicolas; plagnioj@jcrosoft.com; richard.genoud@gmail.com; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
> xfer->speed_hz set
> 
> On 7 March 2013 04:26, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> > commit: 059b8ffeee5b427949872bb6ed5db5ae0788054e
> > cause the atmel spi probing failure.
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: spi-devel-general@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/spi/spi-atmel.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> > index 656d137..1eca815 100644
> > --- a/drivers/spi/spi-atmel.c
> > +++ b/drivers/spi/spi-atmel.c
> > @@ -846,9 +846,9 @@ static int atmel_spi_transfer(struct spi_device *spi,
> struct spi_message *msg)
> >                         }
> >                 }
> >
> > -               /* FIXME implement these protocol options!! */
> > -               if (xfer->speed_hz) {
> > -                       dev_dbg(&spi->dev, "no protocol options
> yet\n");
> > +               if (xfer->speed_hz < spi->max_speed_hz) {
> > +                       dev_dbg(&spi->dev,
> > +                               "speed in transfer less than bus
> speed\n");
> >                         return -ENOPROTOOPT;
> >                 }
> 
> I sent a similar patch to spi-devl a while ago, which Grant said he applied.
> https://patchwork.kernel.org/patch/2165301/
> 
> Can't find the patch in any upstream git tree so I guess Grant hasn't
> pushed it yet.

Sorry, I didn't notice your patch before.
Furthermore, I made this patch based on your and Grant,s email.

I will drop this patch.

> 
> regards
> Joachim Eastwood

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
