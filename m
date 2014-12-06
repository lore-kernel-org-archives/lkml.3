Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaLFEdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:33:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:31067 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaLFEda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:33:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425800903"
Message-ID: <5482866F.70500@intel.com>
Date: Sat, 06 Dec 2014 12:30:39 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Andrew Barnes <umbramalison@gmail.com>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org> <5481AD24.3000703@redhat.com>
In-Reply-To: <5481AD24.3000703@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Andy :)

On 12/05/2014 09:03 PM, Paolo Bonzini wrote:
>
> On 05/12/2014 09:50, Gerd Hoffmann wrote:
>> A few comments on the kernel stuff (brief look so far, also
>> compile-tested only, intel gfx on my test machine is too old).
>>
>>   * Noticed the kernel bits don't even compile when configured as
>>     module.  Everything (vgt, i915, kvm) must be compiled into the
>>     kernel.
>
> I'll add that the patch is basically impossible to review with all the
> XenGT bits still in.  For example, the x86 emulator seems to be
> unnecessary for KVMGT, but I am not 100% sure.
>

This is not ready for merge yet, please wait for a while, we'll have
Xen/KVM specific code separated.

BTW, definitely you are right, the emulator is unnecessary for KVMGT,
and ... unnecessary for XenGT :)

> I would like a clear understanding of why/how Andrew Barnes was able to
> do i915 passthrough (GVT-d) without hacking the ISA bridge, and why this
> does not apply to GVT-g.

AFAIK, the graphics drivers need to figure out the offset of
some MMIO registers, by the IDs of this ISA bridge. It simply won't work
without this information.

Talked with Andy about the pass-through but I don't have his implementation,
CC Andy for his advice :)

>
> Paolo
>

Thanks for review. Would you please also have a look at the issues I mentioned
in the original email? they are most KVM-related: the SRCU trickiness, domid,
and the memslot created in kernel.

Thank you!

--
Thanks,
Jike
