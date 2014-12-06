Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaLFKyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 05:54:38 -0500
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:37958
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751523AbaLFKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 05:54:35 -0500
From: Muthu Mani <muth@cypress.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Topic: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Index: AQHQC5xRLcajWp5gcU6XRxdPQz74M5x6qcmAgASkthA=
Date: Sat, 6 Dec 2014 10:54:26 +0000
Message-ID: <BN1PR06MB069DE9058CA3EE9B5635E1DCC660@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1417241944-17799-1-git-send-email-muth@cypress.com>
 <20141201121533.GE15845@x1>
In-Reply-To: <20141201121533.GE15845@x1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;
x-forefront-prvs: 0417A3FFD2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(164054003)(51164003)(199003)(51704005)(68736005)(122556002)(76576001)(31966008)(107046002)(40100003)(62966003)(77156002)(50986999)(54606007)(120916001)(20776003)(99396003)(64706001)(106116001)(66066001)(97736003)(102836002)(105586002)(106356001)(101416001)(46102003)(2656002)(99286002)(87936001)(21056001)(86362001)(4396001)(54356999)(110136001)(92566001)(76176999)(33656002)(54206007)(74316001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR0601MB725;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB758;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB6Asq1n017867

Thanks for your inputs.

> > +/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > +enum cy_scb_modes {
> > +       CY_USBS_SCB_DISABLED = 0,
> > +       CY_USBS_SCB_UART = 1,
> > +       CY_USBS_SCB_SPI = 2,
> > +       CY_USBS_SCB_I2C = 3
>
> Why have you numbered these individually?

I have changed them as #define's now. These values are not arbitrary.

> > +       /* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > +       switch (interface->cur_altsetting->desc.bInterfaceSubClass) {
> > +       case CY_USBS_SCB_I2C:
> > +               dev_info(&interface->dev, "using I2C interface\n");
> > +               cyusbs23x_devs = cyusbs23x_i2c_gpio_devs;
> > +               ndevs = ARRAY_SIZE(cyusbs23x_i2c_gpio_devs);
>
> Not sure I get this.  Why do you have local variables for these instead of using
> them directly?

We are planning to support other protocols in future. To facilitate that, local variables are used.

> > +       return 0;
> > +
> > +error:
> > +       usb_put_dev(cyusbs->usb_dev);
>
> Isn't there a devm_* version of usb_set_intfdata()?

No.

Thanks,
Muthu

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
