Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3ILHEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:04:32 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45959 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3ILHEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:04:31 -0400
Message-ID: <523168E3.10405@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:40:27 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        mtosatti@redhat.com
Subject: Re: [PATCH V2] Documentation/kvm: Update cpuid documentation for
 steal  time and pv eoi
References: <y> <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130912054453.GA13116@redhat.com>
In-Reply-To: <20130912054453.GA13116@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091206-5564-0000-0000-000009AE9829
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:14 AM, Michael S. Tsirkin wrote:
> On Wed, Sep 04, 2013 at 02:18:46PM +0530, Raghavendra K T wrote:
[...]
>>   ------------------------------------------------------------------------------
>> +KVM_FEATURE_STEAL_TIME             ||     5 || Steal time available at msr
>> +                                   ||       || 0x4b564d03. The feature is enabled
>> +                                   ||       || by guest when host has schedstat
>> +                                   ||       || or task delay accounting support.
>
> Well I think we really should be documenting the host/guest interface
> here.
> After all it starts out
> 	A guest running on a kvm host, can check some of its features using
> 	cpuid.
> And guests really should not try to guess whether host
> has schedstat or task delay accounting support based on this bit.
> So I would just say:
> 	"steal time can be enabled by writing to msr 0x4b564d02"
> just like async pf.
>

It makes sense. will stick to the above line.

>
>> +------------------------------------------------------------------------------
>> +KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
>> +                                   ||       || implementation with a
>> +                                   ||       || paravirtualized version. Available
>> +                                   ||       || at msr 0x4b564d04.
>
> Actually there's no override: guest can still use the
> standard EOI even if PV EOI MSR is enabled.
>
> There's a detailed explanation of PV EOI in
> Documentation/virtual/kvm/msr.txt
> I think the following would be enough:
>
> 	"paravirtualized end of interrupt handler can be enabled by writing to msr 0x4b564d04"
>

Okay.
Thanks Michael.

