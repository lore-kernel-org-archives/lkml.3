Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3DPKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:33:09 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:14235 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3DPKdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:33:07 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
Thread-Topic: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
Thread-Index: AQHON4BZmrb2inLbYUiVqwxvso3ezpjS8UcAgAW2GHA=
Date: Tue, 16 Apr 2013 10:33:02 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E38B@NB-EX-MBX02.diasemi.com>
References: <201304121318.r3CDILZS013210@latitude>
 <5168681A.20405@infradead.org>
In-Reply-To: <5168681A.20405@infradead.org>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@infradead.org]
> Sent: 12 April 2013 21:02
> To: Opensource [Anthony Olech]
> Cc: Dmitry Torokhov; Mark Brown; Samuel Ortiz; Ashish Jangam; Eric
> Andersson; Andrew Jones; linux-input@vger.kernel.org; LKML; David Dajun Chen
> Subject: Re: [NEW DRIVER V4 3/7] DA9058 ONKEY driver
> 
> On 04/12/13 06:05, Anthony Olech wrote:
> > This is the ONKEY component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the CORE component driver of the DA9058 MFD.
> >
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> > ---
> >  drivers/input/misc/Kconfig        |   10 +++
> >  drivers/input/misc/Makefile       |    1 +
> >  drivers/input/misc/da9058_onkey.c |  177
> > +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 188 insertions(+)
> >  create mode 100644 drivers/input/misc/da9058_onkey.c
> >
> > diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> > index 259ef31..bd07b38 100644
> > --- a/drivers/input/misc/Kconfig
> > +++ b/drivers/input/misc/Kconfig
> > @@ -93,6 +93,16 @@ config INPUT_BMA150
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called bma150.
> >
> > +config INPUT_DA9058_ONKEY
> > +	tristate "DA9058 ONKEY support"
> > +	depends on MFD_DA9058
> > +	help
> > +	  Support the ONKEY of DA9058 PMICs as an input device
> > +	  reporting power button status.
> 
> What possible values can a power button status have?
> Must be more than my KISS guess:
> 	this software is running => ON
> 	software not running     => OFF
> eh?

Pressing the button briefly and pressing and holding the button will have
different effects in a mobile device. The press and hold on phones normally
switches them into a sleep state. So the "power button status" is the fact
that the ONKEY is still being held down.

Does that answer your question? or have I missed your point??

[...]
> > +	onkey->irq = platform_get_irq(pdev, 0);
> > +	if (onkey->irq < 0) {
> > +		dev_err(&pdev->dev, "can not get ONKEY IRQ error=%d\n",
> 
> 		                     cannot

The Washington State University language site says:

"These two spellings [cannot/can not] are largely interchangeable, but by far
the most common is 'cannot' and you should probably use it except when you
want to be emphatic: 'No, you can not wash the dog in the Maytag.'"

Since I was not trying to be particularly emphatic, I will change to using 'cannot'
as per your suggestion.

Tony Olech
