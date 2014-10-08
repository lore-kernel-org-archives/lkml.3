Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaJHHJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:09:20 -0400
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:45344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754244AbaJHHJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:09:16 -0400
From: Muthu Mani <muth@cypress.com>
To: Alexandre Courbot <gnurou@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>,
        "Johan Hovold" <johan@kernel.org>
Subject: RE: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Topic: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Index: AQHP4XRW+p3KAYX9WkKxGiOpXWlsnZwkaRoAgAFf9JA=
Date: Wed, 8 Oct 2014 07:09:06 +0000
Message-ID: <405b439b16ea40078718da326343f673@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1412606822-3406-1-git-send-email-muth@cypress.com>
 <CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com>
In-Reply-To: <CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR06MB463;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(13464003)(377454003)(46102003)(21056001)(54356999)(80022003)(50986999)(92566001)(77096002)(64706001)(74316001)(20776003)(19580395003)(76176999)(101416001)(85852003)(66066001)(19580405001)(33646002)(76482002)(108616004)(95666004)(110136001)(2656002)(97736003)(87936001)(99396003)(1411001)(4396001)(31966008)(85306004)(106356001)(105586002)(120916001)(106116001)(40100002)(122556002)(86362001)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR06MB463;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9879RoD022627

> -----Original Message-----
> From: Alexandre Courbot [mailto:gnurou@gmail.com]
> Sent: Tuesday, October 07, 2014 3:34 PM
> To: Muthu Mani
> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; Linus Walleij; Greg Kroah-
> Hartman; linux-i2c@vger.kernel.org; linux-gpio@vger.kernel.org; linux-
> usb@vger.kernel.org; Linux Kernel Mailing List; Rajaram Regupathy; Johan
> Hovold
> Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-
> GPIO adapter
> 
> On Mon, Oct 6, 2014 at 11:47 PM, Muthu Mani <muth@cypress.com> wrote:
> > +
> > +static int cy_gpio_direction_input(struct gpio_chip *chip,
> > +                                       unsigned offset) {
> > +       return 0;
> > +}
> > +
> > +static int cy_gpio_direction_output(struct gpio_chip *chip,
> > +                                       unsigned offset, int value) {
> > +       return 0;
> > +}
> 
> If that chip is capable of both output and input, shouldn't these functions be
> implemented? I think this has already been pointed out in a previous version
> but you did not reply.

Thanks for your inputs.

Only the GPIOs which are configured to be output GPIO can be set.
The set operation would fail trying to set the input or unconfigured GPIOs.
In this version of driver, this support is not added, it can be introduced in future versions.
I will add a TODO note in the code.

> 
> > +
> > +static int cyusbs23x_gpio_probe(struct platform_device *pdev) {
> > +       struct cyusbs23x *cyusbs;
> > +       struct cyusbs_gpio *cy_gpio;
> > +       int ret = 0;
> > +
> > +       dev_dbg(&pdev->dev, "%s\n", __func__);
> 
> > +
> > +       cyusbs = dev_get_drvdata(pdev->dev.parent);
> > +
> > +       cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
> > +       if (cy_gpio == NULL)
> > +               return -ENOMEM;
> > +
> > +       cy_gpio->cyusbs = cyusbs;
> > +       /* registering gpio */
> > +       cy_gpio->gpio.label = dev_name(&pdev->dev);
> > +       cy_gpio->gpio.dev = &pdev->dev;
> > +       cy_gpio->gpio.owner = THIS_MODULE;
> > +       cy_gpio->gpio.base = -1;
> > +       cy_gpio->gpio.ngpio = 12; /* total GPIOs */
> 
> Isn't there a way to get the number of GPIOs from a reliable source?
> If not, please at least use a macro here.

CYUSBS234 has 12 GPIOs in total as per the datasheet. I will add a macro and use it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
