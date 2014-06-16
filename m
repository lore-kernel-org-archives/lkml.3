Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFPCfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:35:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:60169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaFPCfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,483,1400050800"; 
   d="scan'208";a="445834425"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>, David Rientjes <rientjes@google.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>, "naszar@ya.ru" <naszar@ya.ru>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ACPI/Battery: Retry to get Battery information if
 failed during probing
Thread-Topic: [PATCH] ACPI/Battery: Retry to get Battery information if
 failed during probing
Thread-Index: AQHPiQiP5CE4V7ZRAEqfu30HmQDcBJtzBBcg
Date: Mon, 16 Jun 2014 02:35:00 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880262DA59@SHSMSX101.ccr.corp.intel.com>
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com>
 <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com>
 <53995488.20308@intel.com>
 <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com>
 <53996152.2000407@intel.com>
 <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com>
 <539A60FC.1050301@intel.com>
 <alpine.DEB.2.02.1406131445130.31981@chino.kir.corp.google.com>
 <539E528B.90908@intel.com>
In-Reply-To: <539E528B.90908@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5G2ZL7Y026581

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Lan Tianyu
> Sent: Monday, June 16, 2014 10:12 AM
> To: David Rientjes
> Cc: rjw@rjwysocki.net; lenb@kernel.org; naszar@ya.ru; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed during probing
> 
> On 2014å¹´06æœˆ14æ—¥ 05:46, David Rientjes wrote:
> > On Fri, 13 Jun 2014, Lan Tianyu wrote:
> >
> >> How about this?
> >>
> >> -       result = acpi_battery_update(battery, false);
> >> -       if (result)
> >> +
> >> +       /*
> >> +        * Some machines'(E,G Lenovo Z480) ECs are not stable

Just a reminder.

This statement may not be true.
The issue may be caused by the EC driver itself.
So we need to investigate.

> >> +        * during boot up and this causes battery driver fails to be
> >> +        * probed due to failure of getting battery information
> >> +        * from EC sometimes. After several retries, the operation
> >> +        * may work. So add retry code here and 20ms sleep between
> >> +        * every retries.
> >> +        */
> >> +       while (acpi_battery_update(battery, false) && retry--)

If EC hardware is stable, why we need to do retry here?

Thanks and best regards
-Lv

> >> +               msleep(20);
> >> +       if (!retry) {
> >> +               result = -ENODEV;
> >>                 goto fail;
> >> +       }
> >> +
> >
> > I think you want --retry and not retry--.
> 
> My original purpose is to retry 5 times after the first try fails.
> If use "--retry" here, it just retries 4 times.
> 
> >  Otherwise it's possible for the
> > final call to acpi_battery_update() to succeed and now it's returning
> > -ENODEV.
> >
> 
> Yes, it maybe and I will change code like the following.
> 
> while ((result = acpi_battery_update(battery, false)) && retry--)
>        msleep(20);
> if (result)
>        goto fail;
> 
> 
> --
> Best regards
> Tianyu Lan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
