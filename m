Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaGNNsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbaGNNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:47:57 -0400
Message-ID: <53C3DF66.5070102@redhat.com>
Date: Mon, 14 Jul 2014 15:47:18 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kan.liang@intel.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com> <53C3C517.4000500@redhat.com> <20140714120922.GV9918@twins.programming.kicks-ass.net> <53C3CFC1.9070800@redhat.com> <20140714124812.GW9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140714124812.GW9918@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/07/2014 14:48, Peter Zijlstra ha scritto:
>>>> In fact there's no reason why LBR cannot be virtualized (though it does need
>>>> support from the processor), and it may even be possible to support
>>>> OFFCORE_RSP_X in the KVM virtual PMU.
>>>
>>> But its not, so something needs to be done, right?
>>
>> A first thing that could be done, is to have a way for the kernel to detect
>> absence of LBR
>
> Which is exactly what this patch does, no?

A documented (and recommended) way for the kernel to detect it is 
superior though...

>> , for example an all-1s setting of the LBR format field of
>> IA32_PERF_CAPABILITIES.  If Intel can tell us "all 1s will never be used",
>> we can have KVM set the field that way.  The kernel then should disable LBR.
>
> So what's wrong with testing if the MSRs that provide LBR actually work
> or not? That doesn't require any magic co-operation of the host/vm
> machinery and is therefore far more robust.

... because the difference is that whenever we hack the kernel, Windows 
and vTune will remain broken forever.  Whenever we get Intel to make the 
hack part of the spec, there is some hope that Windows and vTune will 
eventually get fixed.

The hack certainly works, I'm not disputing that.

Paolo

