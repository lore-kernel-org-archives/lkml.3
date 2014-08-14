Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaHNN6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:58:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:12549 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbaHNN56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="468704128"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Topic: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Index: AQHPt70v5AdjnnUX70e/nlyx/xxV5JvPkg2AgACMF6A=
Date: Thu, 14 Aug 2014 13:57:49 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5B70B@SHSMSX101.ccr.corp.intel.com>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net>
 <53EC9A29.8090408@linaro.org>
 <20140814124135.GJ16043@twins.programming.kicks-ass.net>
 <53ECB9CD.9040705@linaro.org>
In-Reply-To: <53ECB9CD.9040705@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7EDw5ZC028245



> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Thursday, August 14, 2014 9:30 PM
> To: Peter Zijlstra
> Cc: Liu, Chuansheng; Rafael J. Wysocki; linux-pm@vger.kernel.org; LKML; Liu,
> Changcheng; Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
> back to DEFAULT


> I think the main issue here is to exit the poll_idle loop when an IPI is
> received. IIUC, there is a pm_qos user, perhaps a driver (Chuansheng can
> give more details), setting a very short latency, so the cpuidle
> framework choose a shallow state like the poll_idle and then the driver
> sets a bigger latency, leading to the IPI to wake all the cpus. As the
> CPUs are in the poll_idle, they don't exit until an event make them to
> exit the need_resched() loop (reschedule or whatever). This situation
> can let the CPUs to stand in the infinite loop several seconds while we
> are expecting them to exit the poll_idle and enter a deeper idle state,
> thus with an extra energy consumption.
> 

Exactly, no function error here. But do not enter the deeper C-state will bring more power
consumption, in some mp3 standby mode, even 10% power can be saved.

And this is the patch's aim here.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
