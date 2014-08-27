Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935263AbaH0QGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:06:00 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.106]:50282 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934941AbaH0QF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:05:58 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 12:05:58 EDT
X-Env-Sender: Adam.Thomson@diasemi.com
X-Msg-Ref: server-11.tower-194.messagelabs.com!1409155149!19276709!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Adam Thomson <Adam.Thomson@diasemi.com>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: Jonathan Cameron <jic23@kernel.org>, "knaack.h@gmx.de" <knaack.h@gmx.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iio: core: Propagate error codes from OF layer to
 client drivers
Thread-Topic: [PATCH] iio: core: Propagate error codes from OF layer to
 client drivers
Thread-Index: AQHPwGQgHemXEHhucEq2pC0/gK7aa5vhbKOAgAAMSgCAAPqfAIAAXTaAgAAGhgCAABv1cIABoUnw
Date: Wed, 27 Aug 2014 15:59:05 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB5113C5@SW-EX-MBX01.diasemi.com>
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
		 <53FB5FF7.8020504@kernel.org> <20140825165430.GB14614@roeck-us.net>
	 <1409039490.5256.75.camel@iivanov-dev> <53FC8AB3.2080603@roeck-us.net>
 <1409060908.5256.83.camel@iivanov-dev> 
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7RG6OD3011487

On August 26, 2014 15:36, Adam Thomson wrote:

> On August 26, 2014 14:48, Ivan T. Ivanov wrote:
>
> > On Tue, 2014-08-26 at 06:25 -0700, Guenter Roeck wrote:
> > > On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
> > > > Hi,
> > > >
> > > [ ... ]
> > > >
> > > > Another, less intrusive, solution will be if we revert last patch and explicitly
> > > > check for EPROBE_DEFER on of_ by_name() return. How this sounds?
> > > >
> > > How is that different to the just accepted patch ?
> >
> > You mean this one[1]. I have prepared fix last Friday and forget to
> > check again before posting it, sorry. Please ignore my patch.
> >
> > Thanks,
> > Ivan
> >
> > [1] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
> >
>
> Apologies on my part for fixing one problem and introducing another. Didn't see
> that in my testing, and missed that potential return value when examining the
> code. At the time It looked like the parent function would only expect NULL
> pointers for failure, especially given the non CONFIG_OF definitions of the
> functions. Should've delved further. :(

On August 26, 2014 15:36, Adam Thomson wrote:

> On August 26, 2014 14:48, Ivan T. Ivanov wrote:
>
> > On Tue, 2014-08-26 at 06:25 -0700, Guenter Roeck wrote:
> > > On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
> > > > Hi,
> > > >
> > > [ ... ]
> > > >
> > > > Another, less intrusive, solution will be if we revert last patch and explicitly
> > > > check for EPROBE_DEFER on of_ by_name() return. How this sounds?
> > > >
> > > How is that different to the just accepted patch ?
> >
> > You mean this one[1]. I have prepared fix last Friday and forget to
> > check again before posting it, sorry. Please ignore my patch.
> >
> > Thanks,
> > Ivan
> >
> > [1] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
> >
>
> Apologies on my part for fixing one problem and introducing another. Didn't see
> that in my testing, and missed that potential return value when examining the
> code. At the time It looked like the parent function would only expect NULL
> pointers for failure, especially given the non CONFIG_OF definitions of the
> functions. Should've delved further. :(

In testing patch code for one of our devices, I've verified what Guenter
mentioned previously in this thread, in that iio_channel_get_sys() doesn't
return -EPROBE_DEFER. This means that drivers using the default map approach of
accessing IIO channels will fail to instantiate as they do not know they
need to defer their probe (have seen this with my driver too).

Haven't looked in detail yet as to how, but I guess this is something that will
also need to be addressed.
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
