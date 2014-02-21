Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaBUBjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:39:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:65033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaBUBjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:39:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,515,1389772800"; 
   d="scan'208";a="486930847"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH v4 0/5] Enabling the asynchronous threads for other
 phases
Thread-Topic: [PATCH v4 0/5] Enabling the asynchronous threads for other
 phases
Thread-Index: AQHPLFJ9ymjMhS7FYk21DdHyegrk4pq+8JEg
Date: Fri, 21 Feb 2014 01:38:45 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C27D32@SHSMSX101.ccr.corp.intel.com>
References: <y> <1392690528-10024-1-git-send-email-chuansheng.liu@intel.com>
In-Reply-To: <1392690528-10024-1-git-send-email-chuansheng.liu@intel.com>
Accept-Language: zh-CN, en-US
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

Hello Rafael,

> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Tuesday, February 18, 2014 10:29 AM
> To: rjw@rjwysocki.net; gregkh@linuxfoundation.org; Brown, Len;
> pavel@ucw.cz
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi; Liu,
> Chuansheng
> Subject: [PATCH v4 0/5] Enabling the asynchronous threads for other phases
> 
> Hello,
> 
> This patch series are for enabling the asynchronous threads for the phases
> resume_noirq, resume_early, suspend_noirq and suspend_late.
> 

After dig more about async threads, I found dpm_prepare/complete phases need
them also.

dpm_prepare()
  -- > call pci_pm_prepare() one by one
      -- > call pm_runtime_resume() one by one
        -- > call pci_set_power_state to D3HOT -- > D0

It will cause much time delaying due to d3_delay.
And I made one draft patch to implement the asynchronous threads for dpm_prepare(),
it is really save much time.

If you like it, I can prepare another series patches for dpm_prepare() and dpm_complete(),
thanks.

Best Regards,
