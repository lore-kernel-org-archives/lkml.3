Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3HZL0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:26:47 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:54314 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3HZL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:26:45 -0400
Message-ID: <521B3CEC.5060800@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 17:03:00 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH ] Documentation/kvm: Update cpuid documentation for steal
 time and pv eoi
References: <y> <1377259487-23989-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130826070703.GB23859@redhat.com>
In-Reply-To: <20130826070703.GB23859@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082611-1618-0000-0000-0000048401ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 12:37 PM, Michael S. Tsirkin wrote:
> I would change the description to merely say what the CPUID bits
> mean, and what they mean is exactly that an MSR is valid.
> Use KVM_FEATURE_ASYNC_PF as a template.

Thank you for the review.
Changing the doc accordingly by adding msr info. Please refer below.

>> +KVM_FEATURE_STEAL_TIME             ||     5 || guest accounts fine granularity
>> +                                   ||       || task steal time.
>
> I'm not sure what this phrase means.
> Steal time is a host feature, not a guest feature:
> IIUC if this bit is set, the hypervisor can pass the guest information
> about how much time was spent running other processes outside the VM.

Okay. I guess I need some help here.

I took this from the PARAVIRT_TIME_ACCOUNTING config help. also I saw
that guest is  actually returning the steal time in kvm_steal_clock().

>
>> enabled when
>> +                                   ||       || shedstat or task delay accounting
>> +                                   ||       || is supported by the host.
>
> I think it's enabled by guest, not by host.

true. My understanding was, Guest enables it when host has schedstat or
task delay accounting  on.

I referred to this hunk in kvm/cpuid.c

if (sched_info_on())
    entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
and sched_info_on() is true when schedstat or task delay accounting is
on.

Does this look good?

"Enabled by writing to msr 0x4b564d03. The feature is
enabled by guest when host has schedstat or task delay accounting
support."

>> +KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
>> +                                   ||       || implementation with an optimized
>> +                                   ||       || version.
>
> More exactly "with a paravirtualized version".

Okay. So how does this sound?

"overrides the generic EOI implementation with a paravirtualized
version. This feature is enabled by writing to msr  0x4b564d04."

