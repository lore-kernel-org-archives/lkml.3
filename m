Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbaLMLuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 06:50:17 -0500
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:10511
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965034AbaLMLuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 06:50:14 -0500
From: Muthu Mani <muth@cypress.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexandre Courbot <gnurou@gmail.com>,
        "Johan Hovold" <johan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH v4 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Topic: [PATCH v4 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Index: AQHQCyodC+w9hIU5SEaJMiAJSTjwQJx6xWwAgBK5b9A=
Date: Sat, 13 Dec 2014 11:50:08 +0000
Message-ID: <BN1PR06MB069D2479EA227504993AE5DCC610@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1417192911-16719-1-git-send-email-muth@cypress.com>
 <CACRpkdYbbheP5KTuj7f+2cJXrOjjkRZjR0-bth1DF3kCig6n5A@mail.gmail.com>
In-Reply-To: <CACRpkdYbbheP5KTuj7f+2cJXrOjjkRZjR0-bth1DF3kCig6n5A@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;
x-forefront-prvs: 04244E0DC5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51164003)(4396001)(92566001)(101416001)(21056001)(105586002)(54606007)(54356999)(87936001)(77156002)(120916001)(97736003)(99396003)(33656002)(74316001)(62966003)(20776003)(106116001)(64706001)(86362001)(66066001)(46102003)(106356001)(107046002)(54206007)(99286002)(122556002)(102836002)(40100003)(31966008)(50986999)(110136001)(76176999)(2656002)(68736005)(76576001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR0601MB725;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBDBoQCw022833

> (..)
> > +config GPIO_CYUSBS23X
> > +       tristate "CYUSBS23x GPIO support"
> > +       depends on MFD_CYUSBS23X && USB
>
> Doesn't MFD_CYUSV23X already depend on USB?

Yes, removed USB from GPIO and I2C

> > +       if (gpio->out_gpio & (1 << offset))
> > +               return gpio->out_value & (1 << offset);
>
> Rewrite like this:
>
> if (gpio->out_gpio & BIT(offset))
>              return !!(gpio->out_value & BIT(offset));

Ok, updated for all instances.

Incorporated the comments and posted v5 patch.

Regards,
Muthu

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
