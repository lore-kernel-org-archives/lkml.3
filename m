Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3BACC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:02:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:24407 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3BACC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:02:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="285067130"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Li, Fei" <fei.li@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        anish singh <anish198519851985@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH V3] suspend: enable freeze timeout configuration through
 sys
Thread-Topic: [PATCH V3] suspend: enable freeze timeout configuration
 through sys
Thread-Index: AQHOAB9jeX1OoVIGSkm3lU8CxrRPQJhkP1Kg
Date: Fri, 1 Feb 2013 02:02:21 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A2212E8@SHSMSX101.ccr.corp.intel.com>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <BEC9F67575FA1E429CA7CF5AE9BE36343F0D19@SHSMSX102.ccr.corp.intel.com>
 <CAK7N6vpdmLv-G3q-m9nbWs1jV-s=k9c4gQ-wKOZsMGZrm4AhVw@mail.gmail.com>
 <1503699.1Mx8Tt0bYE@vostro.rjw.lan>
 <BEC9F67575FA1E429CA7CF5AE9BE36343F0F00@SHSMSX102.ccr.corp.intel.com>
 <510B20B5.20900@jp.fujitsu.com>
In-Reply-To: <510B20B5.20900@jp.fujitsu.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1122Vxs023348

> >>>>>> -#define TIMEOUT    (20 * HZ)
> >>>>>> +unsigned int __read_mostly sys_freeze_process_timeout_msecs =
> >> 20000;
> >>>>>
> >>>>> 20000 does not mean 20 seconds since we can select HZ other than
> 1000.
> >>>>> So (20 * HZ) is better than 20000.
> >>>>>
> >>>> [Li, Fei]
> >>>> Are you sure about this, (20*HZ) better than 20000, or you mean 20 *
> >> MSEC_PER_SEC?
> >>> Yasuaki  mean HZ value will not always be 1000.The value of HZ differs for
> >> each
> >>>   supported architecture. In fact, on some supported architectures,
> >>> it even differs between machine types.
> >>> When writing kernel code, never assume that HZ has any given value.
> >>> Right now you are assuming that the delay will be always 20 seconds
> because
> >> of
> >>> your assumption of HZ.
> >>
> >> That's correct, the initial value should be 20 * HZ (i.e. as before).
> > [Li, Fei]
> > Yes, you are right, and IMHO it's already as this in the patch,
> > as 20 * HZ == msecs_to_jiffies(20000), with the current definition
> MSEC_PER_SEC
> > of 1000L. I'll update the default value as 20 * MSEC_PER_SEC in patch V4.
> 
> 20 * MSEC_PER_SEC is not 20 seconds. In Linux, 1 * HZ is 1 seconds.
Sure.

> Thus,
>   - If HZ is defined as 1000, 1000 is 1 seconds.
>   - If HZ is defined as 250, 250 is 1 seconds.
> 
> 20 * MSEC_PER_SEC is always 20000.

> Thus,
>   - If HZ is defined as 1000, 20 * MSEC_PER_SEC is 20 seconds.
>   - If HZ is defined as 250, 20 * MSEC_PER_SEC is 80 seconds.
Could you check the patch again?
The patch are using msecs_to_jiffies(20 * MSEC_PER_SEC), not 20 * MSEC_PER_SEC.
msecs_to_jiffies() has done the conversion from MSEC_PER_SEC to HZ.

> 
> So you should use 20 * HZ if you define timeout at 20 seconds.
> 
> Thanks,
> Yasuaki Ishimatsu.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
