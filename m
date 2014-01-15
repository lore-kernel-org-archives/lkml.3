Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaAOQtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:49:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:31722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbaAOQs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:48:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="459294743"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fcr@adinet.com.uy" <fcr@adinet.com.uy>,
        "l@dorileo.org" <l@dorileo.org>, "Zheng, Lv" <lv.zheng@intel.com>
Subject: RE: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Thread-Topic: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Thread-Index: AQHPEgAMDabhH/W2zkifeGkFDk5AKJqGY3+AgAAFZYD//5Xj0A==
Date: Wed, 15 Jan 2014 16:48:55 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7BF73F@ORSMSX103.amr.corp.intel.com>
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com>
 <5255063.SeYbBZqxVQ@vostro.rjw.lan> <20140114212406.GA25438@srcf.ucam.org>
 <4100200.O09E65sAKi@vostro.rjw.lan> <52D69E57.5020208@intel.com>
 <20140115144720.GA23218@srcf.ucam.org> <52D6A3FF.8070100@intel.com>
In-Reply-To: <52D6A3FF.8070100@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0FGnBhD010156

If an object does not exist, AE_NOT_FOUND is returned by evaluate_object.

If the package is empty or has insufficient elements, something like AE_AML_OPERAND_VALUE is returned.


> -----Original Message-----
> From: Lan, Tianyu
> Sent: Wednesday, January 15, 2014 7:07 AM
> To: Matthew Garrett
> Cc: Rafael J. Wysocki; Dmitry Torokhov; lenb@kernel.org; linux-
> acpi@vger.kernel.org; linux-kernel@vger.kernel.org; fcr@adinet.com.uy;
> l@dorileo.org; Zheng, Lv; Moore, Robert
> Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
> 
> On 01/15/2014 10:47 PM, Matthew Garrett wrote:
> > On Wed, Jan 15, 2014 at 10:42:31PM +0800, Lan Tianyu wrote:
> >> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c index
> >> fbf1ace..e98fa83 100644
> >> --- a/drivers/acpi/battery.c
> >> +++ b/drivers/acpi/battery.c
> >> @@ -770,7 +770,7 @@ static int acpi_battery_add(struct acpi_device
> *device)
> >>          device->driver_data = battery;
> >>          mutex_init(&battery->lock);
> >>          mutex_init(&battery->sysfs_lock);
> >> -       if (acpi_has_method(battery->device->handle, "_BIX"))
> >> +       if (acpi_evaluate_object(device->handle, "_BIX", NULL,
> >> + &buffer);)
> >>                  set_bit(ACPI_BATTERY_XINFO_PRESENT,
> >> &battery->flags);
> >
> > Doesn't acpi_evaluate_object() return 0 on success? I think:
> >
> > if (ACPI_SUCESS(acpi_evaluate_object(device->handle, "_BIX", NULL,
> > &buffer))
> >
> 
> Yes, Sorry for oops.
> 
> > But maybe we should check for existence first and give an FW_BUG
> > message to indicate an invalid _BIX?
> 
> Yes, this is a good idea.
> 
> Another point, the acpi_evaluate_object should return different error code
> for these two cases(no _BIX and wrong size.). I wonder whether we can use
> the error code to determine it belong which case?
> >
> 
> 
> --
> Best Regards
> Tianyu Lan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
