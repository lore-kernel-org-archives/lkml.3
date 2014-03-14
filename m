Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaCNXIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:08:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63768 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaCNXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:13 -0400
Date: Fri, 14 Mar 2014 16:07:10 -0700
From: Venkatesh Srinivas <venkateshs@google.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        mingo@elte.hu, zheng.z.yan@intel.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL
 PMU.
Message-ID: <20140314230710.GA5487@google.com>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
 <20140314084429.GO27965@twins.programming.kicks-ass.net>
 <20140314135652.GE3793@tassilo.jf.intel.com>
 <CAHdzE--apBc_AQKiMUxubiX=pacUqebTfnQ+i0Kho1K2=Om1bw@mail.gmail.com>
 <20140314161745.GH3793@tassilo.jf.intel.com>
 <53233516.10005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <53233516.10005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:57:58AM -0600, David Ahern wrote:
>On 3/14/14, 10:17 AM, Andi Kleen wrote:
>>>The Intel ISR section for RDMSR seems to say: "Specifying a reserved
>>>or unimplemented
>>>MSR address in ECX will also cause a general protection exception".
>>>
>>> From a guest's perspective, MSR_RAPL_POWER_UNIT is unimplemented; kvm matches
>>>this behavior.
>>
>>MSRs are model specific and defined per model number. If you report a model
>>number you're expected to implement the MSRs defined for that model number.
>>
>>AFAIK Xen just reports 0 for unknown MSRs (and I'm surprised KVM doesn't too)
>>
>>I would suggest to fix KVM.
>
>I believe ignore_msrs parameter to kvm handles that.
>
>David

Hi,

cc-ing the virtualization mailing list for more detail on the kvm
default for ignore_msrs (it defaults off).

1) Just returning 0 for unsupported MSRs is not workable -- 0 may be a
    meaningful value for an MSR. RDMSR/WRMSR already have a mechanism
    for out-of-band errors, #GP.

2) #GP has been KVM's default behavior for quite some time. Even if we
    believe changing KVM's default is appropriate, Linux w/ the RAPL PMU
    code enabled will fail to boot on existing KVM versions. W/ this
    change, Linux will boot on prior KVM versions.

Thanks,
-- vs;
