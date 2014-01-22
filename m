Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaAVG00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:26:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:33268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaAVG0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:26:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="462667505"
From: "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
Thread-Topic: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
Thread-Index: AQHPFnLkmoIEnd0u3UmWxfIRHgMuSJqOuuow//+TAICAAWHWgIAAmKfA
Date: Wed, 22 Jan 2014 06:26:20 +0000
Message-ID: <630F9443351D2B4BB7EC6BAE6B6B08342549CF6A@SHSMSX104.ccr.corp.intel.com>
References: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
	<CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
	<630F9443351D2B4BB7EC6BAE6B6B08342549C5DC@SHSMSX104.ccr.corp.intel.com>
	<CAKohpo=ng-B6kLdWxBn_cNsWNVsYaNAD-ZzQLLOfkbj+FDg_fg@mail.gmail.com>
 <CAKohpokHi=yuGJm2Nf-TAMVhGQ8Do02j+s6z3eenKRzoW8pv7g@mail.gmail.com>
In-Reply-To: <CAKohpokHi=yuGJm2Nf-TAMVhGQ8Do02j+s6z3eenKRzoW8pv7g@mail.gmail.com>
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
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: Wednesday, January 22, 2014 1:18 PM
> To: Li, Zhuangzhi
> Cc: Rafael J. Wysocki; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org;
> Linux Kernel Mailing List; Liu, Chuansheng
> Subject: Re: [PATCH] cpufreq: Align all CPUs to the same frequency if using
> shared clock
> 
> On 21 January 2014 13:42, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 21 January 2014 12:56, Li, Zhuangzhi <zhuangzhi.li@intel.com> wrote:
> >> Thanks for reviewing.
> >
> > Its my job :)
> >
> >> Sorry for make you misunderstanding, on our x86 platform, we want all the
> CPUs share one policy by setting CPUFREQ_SHARED_TYPE_ALL, not share one
> HW clock line.
> >
> > I see.. Then probably your patch makes sense. But it is obviously not
> > required for every platform that exists today.
> >
> > Please update it to do it only for drivers that have set
> > CPUFREQ_SHARED_TYPE_ALL..
> 
> One more thing, who has set different frequencies to these cores?
> I hope kernel hasn't ?
> 
> In that case, probably you are fixing a bootloader bug in kernel?
> What about doing this in bootloader then?
I don't think it's a real bug in bootloader, the bootloader can set CPUs to different frequencies according to actually requirements(Power saving first or Performance first),
the CPUs freq policy are initialized in kernel, if the kernel want to share one CPU policy(using CPUFREQ_SHARED_TYPE_ALL type), it should ensure all CPUs frequencies aligned first,
don't depend on the bootloader CPUs Pre-states, then the kernel can have better compatibility.

If the kernel uses CPUFREQ_SHARED_TYPE_ALL policy, the patch can ensure these:
1. If all CPUs are in the same P-state, it does nothing when cpufreq registering
2. If the CPUs are in different P-states, all the other CPUs are aligned once to current frequency of CPU0 according to the present policy.
> 
> --
> virehs
