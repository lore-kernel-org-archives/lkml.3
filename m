Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaAUI5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:57:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:5651 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaAUI5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:57:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,695,1384329600"; 
   d="scan'208";a="468235532"
From: "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Enabling the asynchronous threads for other phases
Thread-Topic: [PATCH 0/5] Enabling the asynchronous threads for other phases
Thread-Index: AQHPFb0YwCGp7bd/kE6h+p2RfRZt+5qO4d5g
Date: Tue, 21 Jan 2014 08:57:27 +0000
Message-ID: <630F9443351D2B4BB7EC6BAE6B6B08342549C6AB@SHSMSX104.ccr.corp.intel.com>
References: <y> <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
In-Reply-To: <1390207479-26064-1-git-send-email-chuansheng.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Monday, January 20, 2014 4:45 PM
> To: rjw@rjwysocki.net; gregkh@linuxfoundation.org; pavel@ucw.cz; Brown, Len
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Chuansheng;
> Li, Zhuangzhi
> Subject: [PATCH 0/5] Enabling the asynchronous threads for other phases
> 
> Hello,
> 
> This patch series are for enabling the asynchronous threads for the phases
> resume_noirq, resume_early, suspend_noirq and suspend_late.
> 
> Just like commit 5af84b82701a and 97df8c12995, with async threads it will
> reduce the system suspending and resuming time significantly.
> 
> With these patches, in my test platform, it saved 80% time in resume_noirq
> phase.
> 
> Has done the suspend-resume stress test for a long time, please help to
> review.
> 
> Best Regards,
> 
> [PATCH 1/5] PM: Adding two flags for async suspend_noirq and
> [PATCH 2/5] PM: Enabling the asynchronous threads for resume_noirq
> [PATCH 3/5] PM: Enabling the asyncronous threads for resume_early
> [PATCH 4/5] PM: Enabling the asyncronous threads for suspend_noirq
> [PATCH 5/5] PM: Enabling the asyncronous threads for suspend_late

After applied the above five patches, there was no issue observed during 1000 cycles suspend/resume stress test on Baytrail platform.
Tested-by: lizhuangzhi <zhuangzhi.li@intel.com>
> 
>  drivers/base/power/main.c |  240
> ++++++++++++++++++++++++++++++++++++---------
>  include/linux/pm.h        |    2 +
>  2 files changed, 197 insertions(+), 45 deletions(-)

