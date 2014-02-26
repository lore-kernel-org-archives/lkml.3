Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaBZJAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:00:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:38259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaBZJAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:00:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="481980318"
Message-ID: <530DAC5E.20408@intel.com>
Date: Wed, 26 Feb 2014 16:57:02 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>	<530D53EF.9090706@amacapital.net> <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
In-Reply-To: <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 03:04 PM, Stephane Eranian wrote:
> On Wed, Feb 26, 2014 at 3:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On 02/17/2014 10:07 PM, Yan, Zheng wrote:
>>>
>>> This patch series adds LBR call stack support. User can enabled/disable
>>> this through an sysfs attribute file in the CPU PMU directory:
>>>  echo 1 > /sys/bus/event_source/devices/cpu/lbr_callstack
>>
>> This seems like an unpleasant way to control this.  It would be handy to
>> be able to control this as an option to perf record.
>>
> That would mean you'd be root for perf.
> Or are you suggesting a perf event option? But then, you'd expose arch-specific
> feature at the API level.
> 

Another option is enable this feature by default if hardware supports it. But it
causes LBR contention between events that want callstack and evnets that want LBR.

Regards
Yan, Zheng
