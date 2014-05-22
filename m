Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaEVFDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:03:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:4009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaEVFDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:03:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,884,1392192000"; 
   d="scan'208";a="515815210"
Message-ID: <537D852B.8070106@linux.intel.com>
Date: Wed, 21 May 2014 22:03:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [x86, vdso] cfda7bb9ecb: +14.7% will-it-scale.per_thread_ops
References: <537AEF2D.9040207@intel.com> <CALCETrVFbo1yb7FyCH1Y=pHb89VPt9ycx0C-wv2A7h=CzwwdGA@mail.gmail.com> <20140522015448.GA23196@localhost>
In-Reply-To: <20140522015448.GA23196@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 06:54 PM, Fengguang Wu wrote:
>>>
>>> test case: nhm4/will-it-scale/sched_yield
>>>
>>> 3d7ee969bffcc98  cfda7bb9ecbf9d96264bb5bad
>>> ---------------  -------------------------
>>>     5497021 ~ 0%     +14.7%    6303424 ~ 0%  TOTAL
>>> will-it-scale.per_thread_ops
>>>        0.54 ~ 0%      +5.6%       0.57 ~ 0%  TOTAL will-it-scale.scalability
>>>     6209483 ~ 0%      +1.6%    6305917 ~ 0%  TOTAL
>>> will-it-scale.per_process_ops
>>>        2455 ~ 5%     +16.9%       2870 ~ 5%  TOTAL cpuidle.C1-NHM.usage
>>>        8829 ~ 7%     +15.2%      10169 ~10%  TOTAL
>>> slabinfo.kmalloc-64.active_objs
>>>       24.13 ~12%     +48.9%      35.93 ~14%  TOTAL time.user_time
>>>         393 ~ 0%      -3.0%        382 ~ 1%  TOTAL time.system_time
>>>
>>
>> Is this a speedup or a slowdown?
> 
> It's a speedup. The will-it-scale/sched_yield test case's throughput
> increased by +14.7% (multi-thread case) and +1.6% (multi-process case).
> 
> However the CPU %user time increased more, by +48.9%.
> 

That would be consistent with spending less time in the kernel, no?

But I agree... that is completely bizarre.  That checkin should have
absolutely zero effect on performance.

	-hpa

