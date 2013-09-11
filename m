Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3IKX4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:56:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:51774 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab3IKX4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,887,1371106800"; 
   d="scan'208";a="400258663"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>, "Li, Fei" <fei.li@intel.com>
Subject: RE: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
Thread-Topic: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
Thread-Index: AQHOruoV4L9/pT59VkKIzd8gZ7Ja55nBNb6g
Date: Wed, 11 Sep 2013 23:55:53 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B1F71E@SHSMSX101.ccr.corp.intel.com>
References: <1378921377.26153.26.camel@cliu38-desktop-build>
 <37297227.So9eVdeflb@vostro.rjw.lan>
In-Reply-To: <37297227.So9eVdeflb@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BNuGYA008624

Hello Rafael,

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Wednesday, September 11, 2013 8:37 PM
> To: Liu, Chuansheng
> Cc: lenb@kernel.org; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
> Li, Zhuangzhi; Li, Fei
> Subject: Re: [PATCH] ACPI / osl: implement acpi_os_sleep() with msleep()
> 
> On Thursday, September 12, 2013 01:42:57 AM Chuansheng Liu wrote:
> >
> > Currently the acpi_os_sleep() is using the schedule_timeout_interruptible(),
> > which can be interrupted by signal, which causes the real sleep time is
> shorter.
> >
> > According to the ACPI spec:
> > The Sleep term is used to implement long-term timing requirements.
> > Execution is delayed for at least the required number of milliseconds.
> >
> > The sleeping time should be at least of the required number msecs, here
> > using msleep() to implement it.
> >
> > Also if the real time is shorter, we meet the device POWER ON issue.
> 
> What exactly is the "power on" issue?
The case is we have one device _PS0 method in platform.asl like below:
Write the pmcsr REG to power on;
Sleep 10ms;
Read some registers;
...

Here sometimes the actual sleeping time is < 10ms, it causes the following actions failed due this device
need 10ms to power on successfully.

> 
> Rafael
> 
> 
> > CC: lizhuangzhi <zhuangzhi.li@intel.com>
> > CC: Li Fei <fei.li@intel.com>
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/acpi/osl.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index e5f416c..b1629b5 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -820,7 +820,7 @@ acpi_status acpi_os_remove_interrupt_handler(u32
> irq, acpi_osd_handler handler)
> >
> >  void acpi_os_sleep(u64 ms)
> >  {
> > -	schedule_timeout_interruptible(msecs_to_jiffies(ms));
> > +	msleep(ms);
> >  }
> >
> >  void acpi_os_stall(u32 us)
> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
