Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161755Ab3DENN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:13:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:5481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161666Ab3DENN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:13:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="281274638"
From: "Li, Fei" <fei.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ohad Ben-Cohen <ohad@wizery.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFYonEn/T666UekGB/wDuM/Dex5jG3CcAgABXQQCAAACSAIAAnl5Q
Date: Fri, 5 Apr 2013 13:13:09 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE363442ACED@SHSMSX102.ccr.corp.intel.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <CAK=WgbbDhfLa1uQn3v0Lu5iOLL5QgGxKuOVrq9AKD9fLtb42FQ@mail.gmail.com>
 <1988602.WZduyKA6Mt@vostro.rjw.lan> <4371647.pFRZSjEjHz@vostro.rjw.lan>
In-Reply-To: <4371647.pFRZSjEjHz@vostro.rjw.lan>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r35DDR8W009326

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, April 05, 2013 7:42 PM
> To: Ohad Ben-Cohen; Liu, Chuansheng
> Cc: Li, Fei; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in
> pm_runtime_get_sync failed case
> 
> On Friday, April 05, 2013 01:39:58 PM Rafael J. Wysocki wrote:
> > On Friday, April 05, 2013 09:27:40 AM Ohad Ben-Cohen wrote:
> > > Hi Li,
> > >
> > > On Thu, Feb 28, 2013 at 10:02 AM, Li Fei <fei.li@intel.com> wrote:
> > > >
> > > > Even in failed case of pm_runtime_get_sync, the usage_count
> > > > is incremented. In order to keep the usage_count with correct
> > > > value and runtime power management to behave correctly, call
> > > > pm_runtime_put(_sync) in such case.
> > >
> > > Is it better then to call pm_runtime_put_noidle instead? This way
> > > we're sure to only take care of usage_count without ever calling any
> > > underlying pm handler.
> >
> > Both would break code that does
> >
> >  pm_runtime_get_sync(dev);
> >
> >  <device access>
> >
> >  pm_runtime_put(dev);
> >
> > without checking the result of pm_runtime_get_sync() - which BTW is
> completely
> > unnecessary in the majority of cases.
> 
> Sorry, scratch that.  I should have had a closer look at the context.
> 
> Yes, it better to call pm_runtime_put_noidle() in this case.
> 
Thanks for your feedback.
I'll upload patch V2 for this topic.

Thanks,
Fei

> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
