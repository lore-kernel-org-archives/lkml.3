Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973AbaLLQDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:03:42 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:49328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932640AbaLLQDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:03:40 -0500
From: Muthu Mani <muth@cypress.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH v4 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Thread-Topic: [PATCH v4 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Thread-Index: AQHQC5xnwybedbuoIU6wm8sokCsmuJx9u42AgAGR50A=
Date: Fri, 12 Dec 2014 16:03:34 +0000
Message-ID: <BN1PR06MB06912FCBAAE08006E352008CC600@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1417241986-17841-1-git-send-email-muth@cypress.com>
 <20141203110755.GA1039@katana>
In-Reply-To: <20141203110755.GA1039@katana>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0601MB725;
x-forefront-prvs: 04238CD941
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51164003)(189002)(52604005)(51704005)(199003)(164054003)(99286002)(122556002)(102836002)(31966008)(54206007)(2656002)(76176999)(76576001)(68736005)(110136001)(50986999)(120916001)(77156002)(74316001)(62966003)(97736003)(33656002)(99396003)(101416001)(21056001)(105586002)(4396001)(92566001)(87936001)(106356001)(54356999)(107046002)(86362001)(106116001)(20776003)(64706001)(66066001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO2PR0601MB725;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for reviewing the code.

> > +/*
> > + * It exposes sysfs entries under the i2c adapter for getting the i2c
> > +transfer
> > + * status, reset i2c read/write module, get/set nak and stop bits.
> > + */
>
> Yes, I see that. Yet, I don't know why they are needed? The driver should
> know when to send NAK/STOP. Why expose that to the user? And why do
> we need a reset? Are there stability problems? What about unloading the
> module? And what is the use case for reading the status?

For repeated start (Sr) scenario, the STOP bit will not be set.
For dummy write scenario (writing EEPROM address from I2C EEPROM slave), the STOP bit should not be set. But, for normal I2C write, the STOP bit should be set.
We provide control to user to control when to STOP/NAK to handle different scenarios.

The reset is an additional provision given to user to reset the I2C read or write engines. It does not require unloading I2C kernel module.
The status indicates the information about the last i2c read/write operation.

>
> > +       if (num > 1) {
> > +               dev_err(&adapter->dev, "i2c_msg number is > 1\n");
> > +               return -EIO;
> > +       }
>
> Ouch! Don't you have any repeated start option somewhere?

In this version of the driver, we handle only single i2c message. In future iterations, we will add support for multiple i2c messages.

Thanks,
Muthu

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
