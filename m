Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3LSSQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:16:05 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.166]:14035 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab3LSSQD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:16:03 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-3.tower-39.messagelabs.com!1387476959!15258821!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
CC: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
Subject: RE: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052 power driver
Thread-Topic: [lm-sensors] [PATCH V1] fix adc to voltage calculation in
 da9052 power driver
Thread-Index: AQHO/OWp3CDZH5Rk5EWcdbF+IlJzu5pb0rZg
Date: Thu, 19 Dec 2013 18:15:57 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51847AC44F@NB-EX-MBX02.diasemi.com>
References: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
 <20131218163234.714a166c@endymion.delvare>
 <24DF37198A1E704D9811D8F72B87EB51847ABF61@NB-EX-MBX02.diasemi.com>
 <20131218172402.GA18892@roeck-us.net>
 <24DF37198A1E704D9811D8F72B87EB51847AC2C3@NB-EX-MBX02.diasemi.com>
 <20131219155454.40100f4d@endymion.delvare>
 <20131219181049.GA6854@roeck-us.net>
In-Reply-To: <20131219181049.GA6854@roeck-us.net>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> Roeck
> Sent: 19 December 2013 18:11
> To: Jean Delvare
> Cc: Opensource [Anthony Olech]; lm-sensors@lm-sensors.org; Anton
> Vorontsov; David Woodhouse; linux-kernel@vger.kernel.org; David Dajun
> Chen
> Subject: Re: [lm-sensors] [PATCH V1] fix adc to voltage calculation in da9052
> power driver
> On Thu, Dec 19, 2013 at 03:54:54PM +0100, Jean Delvare wrote:
> > Hi Anthony,
> >
> [ ... ]
> > BTW, you (and we) probably shouldn't waste too much energy on this.
> > ADCs are only accurate to some degree anyway. If you take the
> > components connected to the input into consideration, the accuracy
> > gets even worse. For example, if the input voltage must be scaled down
> > to fit in the ADC's range, you need at least one resistor, which in
> > best cases will have a 1% accurate value (known as tolerance.) That's
> > ten times the LSB of your 10-bit ADC, at which point / 1023 or / 1024
> > really makes no practical difference. Sub-percent tolerant resistors
> > are expensive and rare in consumer electronics in my experience.
> True, but on the other side (and after looking into the datasheet) the driver
> already calculated the voltage on adc4..6 correctly, so unless you disagree I
> would like to apply the hwmon patch to -next for consistency.
> Thanks,
> Guenter

OK, thanks,
Tony Olech
