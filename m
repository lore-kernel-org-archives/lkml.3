Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaCNQ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:58:22 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49329 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbaCNQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:58:01 -0400
Message-ID: <53233516.10005@gmail.com>
Date: Fri, 14 Mar 2014 10:57:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>,
        Venkatesh Srinivas <venkateshs@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, mingo@elte.hu,
        zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL
 PMU.
References: <1394739386-22260-1-git-send-email-venkateshs@google.com> <20140314084429.GO27965@twins.programming.kicks-ass.net> <20140314135652.GE3793@tassilo.jf.intel.com> <CAHdzE--apBc_AQKiMUxubiX=pacUqebTfnQ+i0Kho1K2=Om1bw@mail.gmail.com> <20140314161745.GH3793@tassilo.jf.intel.com>
In-Reply-To: <20140314161745.GH3793@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/14, 10:17 AM, Andi Kleen wrote:
>> The Intel ISR section for RDMSR seems to say: "Specifying a reserved
>> or unimplemented
>> MSR address in ECX will also cause a general protection exception".
>>
>>  From a guest's perspective, MSR_RAPL_POWER_UNIT is unimplemented; kvm matches
>> this behavior.
>
> MSRs are model specific and defined per model number. If you report a model
> number you're expected to implement the MSRs defined for that model number.
>
> AFAIK Xen just reports 0 for unknown MSRs (and I'm surprised KVM doesn't too)
>
> I would suggest to fix KVM.

I believe ignore_msrs parameter to kvm handles that.

David

