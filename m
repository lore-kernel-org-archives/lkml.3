Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaIDNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:51:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:1131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIDNvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="594539427"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH 3/3] cpuidle: Using the wake_up_all_idle_cpus() to wake
 up all idle cpus
Thread-Topic: [PATCH 3/3] cpuidle: Using the wake_up_all_idle_cpus() to wake
 up all idle cpus
Thread-Index: AQHPyEBoVaPb9UMB/02uCuyEjBufrZvw+adg
Date: Thu, 4 Sep 2014 13:39:38 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E6B3E3@SHSMSX101.ccr.corp.intel.com>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com>
 <1409815075-4180-3-git-send-email-chuansheng.liu@intel.com>
 <540862AA.7060907@linaro.org>
In-Reply-To: <540862AA.7060907@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84Dq5bN010128



> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Thursday, September 04, 2014 9:02 PM
> To: Liu, Chuansheng; peterz@infradead.org; luto@amacapital.net;
> rjw@rjwysocki.net; mingo@redhat.com
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Changcheng;
> Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH 3/3] cpuidle: Using the wake_up_all_idle_cpus() to wake up
> all idle cpus
> 
> On 09/04/2014 09:17 AM, Chuansheng Liu wrote:
> > Currently kick_all_cpus_sync() or smp_call_function() can not
> > break the polling idle cpu immediately.
> >
> > Here using wake_up_all_idle_cpus() which can wake up the polling idle
> > cpu quickly is much helpful for power.
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> So IIUC, kick_all_cpus_sync is a broken function, right ?
> 
> Wouldn't make sense to replace all calls to kick_all_cpus by
> wake_up_all_idle_cpus ? and remove this broken function ?
My initial patch(V1) indeed do it, but Andy pointed out some callers of kick_all_cpus_sync()
really want the old behavior.

My fault again that do not have the detailed changelog for the patches.

Pasted the comments from Andy:
==
> Currently using smp_call_function() just woke up the corresponding
> cpu, but can not break the polling idle loop.
>
> Here using the new sched API wake_up_if_idle() to implement it.

kick_all_cpus_sync has other callers, and those other callers want the
old behavior.  I think this should be a new function.

--Andy
==


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
