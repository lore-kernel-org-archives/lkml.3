Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaCNPVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:21:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44653 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaCNPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140314135652.GE3793@tassilo.jf.intel.com>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
	<20140314084429.GO27965@twins.programming.kicks-ass.net>
	<20140314135652.GE3793@tassilo.jf.intel.com>
Date: Fri, 14 Mar 2014 08:21:07 -0700
Message-ID: <CAHdzE--apBc_AQKiMUxubiX=pacUqebTfnQ+i0Kho1K2=Om1bw@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL PMU.
From: Venkatesh Srinivas <venkateshs@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, mingo@elte.hu,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 6:56 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Fri, Mar 14, 2014 at 09:44:29AM +0100, Peter Zijlstra wrote:
>> On Thu, Mar 13, 2014 at 12:36:26PM -0700, Venkatesh Srinivas wrote:
>> > CPUs which should support the RAPL counters according to
>> > Family/Model/Stepping may still issue #GP when attempting to access
>> > the RAPL MSRs. This may happen when Linux is running under KVM and
>> > we are passing-through host F/M/S data, for example. Use rdmsrl_safe
>> > to first access the RAPL_POWER_UNIT MSR; if this fails, do not
>> > attempt to use this PMU.
>>
>> This kvm thing is getting tedious :-(
>
> It sounds bogus to me too, VMs are supposed to return 0
> on reading unknown MSRs, no #GP.

The Intel ISR section for RDMSR seems to say: "Specifying a reserved
or unimplemented
MSR address in ECX will also cause a general protection exception".

>From a guest's perspective, MSR_RAPL_POWER_UNIT is unimplemented; kvm matches
this behavior.

Thanks,
-- vs;
