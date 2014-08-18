Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaHRAMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 20:12:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:53632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaHRAMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 20:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,881,1400050800"; 
   d="scan'208";a="586122239"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH 2/3] smp: re-implement the kick_all_cpus_sync() with
 wake_up_if_idle()
Thread-Topic: [PATCH 2/3] smp: re-implement the kick_all_cpus_sync() with
 wake_up_if_idle()
Thread-Index: AQHPuJ9b+RaU3y8RsUigiUplyVXz7pvVgIxg
Date: Mon, 18 Aug 2014 00:12:39 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5D3FB@SHSMSX101.ccr.corp.intel.com>
References: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com>
 <1408086085-16691-2-git-send-email-chuansheng.liu@intel.com>
 <CALCETrUQ7x+kPYewNSUeAX5=0yVmqYWca9XCXtUbM0SNZ2ou+Q@mail.gmail.com>
In-Reply-To: <CALCETrUQ7x+kPYewNSUeAX5=0yVmqYWca9XCXtUbM0SNZ2ou+Q@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7I0D5pp010871

Hello Andy,

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Friday, August 15, 2014 11:41 PM
> To: Liu, Chuansheng
> Cc: Peter Zijlstra; Daniel Lezcano; Rafael J. Wysocki; Ingo Molnar;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Changcheng;
> Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH 2/3] smp: re-implement the kick_all_cpus_sync() with
> wake_up_if_idle()
> 
> On Fri, Aug 15, 2014 at 12:01 AM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> > Currently using smp_call_function() just woke up the corresponding
> > cpu, but can not break the polling idle loop.
> >
> > Here using the new sched API wake_up_if_idle() to implement it.
> 
> kick_all_cpus_sync has other callers, and those other callers want the
> old behavior.  I think this should be a new function.
> 
Yes, seems some current users of kick_all_cpus_sync() need IPI indeed,
will try to send out patch V2 with one new function.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
