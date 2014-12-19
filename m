Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaLSL7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:59:34 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47954 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaLSL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:59:32 -0500
Message-ID: <5494131E.9030505@redhat.com>
Date: Fri, 19 Dec 2014 12:59:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-14-git-send-email-feng.wu@intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>	<549307A5.3060305@redhat.com> <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00230A5F8@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 02:30, Wu, Feng wrote:
>>> How this can work well? All subsequent interrupts are delivered to
>>> one vCPU? It shouldn't be the best solution, need more consideration.
>>
>> Well, it's a hardware limitation.  The alternative (which is easy to
>> implement) is to only do PI for single-CPU interrupts.  This should work
>> well for multiqueue NICs (and of course for UP guests :)), so perhaps
>> it's a good idea to only support that as a first attempt.
>>
>> Paolo
> 
> Paolo, what do you mean by "single-CPU interrupts"? Do you mean we don't
> support lowest priority interrupts for PI? But Linux OS uses lowest priority
> for most of the case? If so, we can hardly get benefit from this feature for
> Linux guest OS.

You can post lowest priority interrupts if they are delivered to a
single CPU, in which case they are effectively fixed priority.

If they are broadcast to multiple CPUs, do not post them.

Paolo
