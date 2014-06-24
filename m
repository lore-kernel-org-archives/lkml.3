Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaFXKjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:39:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27183 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752081AbaFXKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:39:54 -0400
Message-ID: <53A9556D.3000003@arm.com>
Date: Tue, 24 Jun 2014 11:39:41 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: KVM: user_mem_abort: support stage 2 MMIO page
 mapping
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org> <1395785294-2545-2-git-send-email-kim.phillips@linaro.org> <20140506180448.GH3066@lvm> <87bnvaotei.fsf@approximate.cambridge.arm.com> <20140507145557.GJ3066@lvm> <20140624102327.GA9121@arm.com>
In-Reply-To: <20140624102327.GA9121@arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/14 11:23, Will Deacon wrote:
> On Wed, May 07, 2014 at 03:55:57PM +0100, Christoffer Dall wrote:
>> On Wed, May 07, 2014 at 10:00:21AM +0100, Marc Zyngier wrote:
>>> On Tue, May 06 2014 at  7:04:48 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>>>> On Tue, Mar 25, 2014 at 05:08:14PM -0500, Kim Phillips wrote:
>>>>> Use the correct memory type for device MMIO mappings: PAGE_S2_DEVICE.
>>>>>
>>>>> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
>>>>> ---
>>>>>  arch/arm/kvm/mmu.c | 11 ++++++++---
>>>>>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> [...]
> 
>>>> I think this looks reasonable.
>>>>
>>>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>
>>> I feel like I'm missing some context here, and the commit message is way
>>> too terse for me to make sense of it.
>>>
>>> So far, we can only get into user_mem_abort on a Stage-2 fault
>>> (translation or permission) for memory. How can we suddenly get here for
>>> a *device* fault? Do we get a special kind of memslot?
>>>
>>> I'm not saying the patch does anything wrong, but I'd like to understand
>>> the rationale behind it. On its own, it doesn't make much sense.
>>>
>> Think device passthrough.  There's nothing preventing user space from
>> setting up a memory region to point to device memory (through VFIO or
>> /dev/mem).  If that's done, we should enforce device memory properties
>> so writes don't linger around in the cache to be written some time later
>> when that device memory potentially doesn't belong to the VM anymore.
>>
>> This is just one tiny piece of all of them to make device passthrough
>> work, and we could hold off with this patch until we have something more
>> complete.  On the other hand, we need to start somewhere, and this is
>> hardly intrusive and is functionally correct even though you don't have
>> a full device passthrough setup.
> 
> Please can you queue this patch up? I need it for my VFIO work, where I'm
> registering the PCI BARs using KVM_SET_USER_MEMORY_REGION.
> 
> Without this, I'd have to trap all accesses and do pread/pwrite from
> kvmtool instead of mmaping the regions straight through.

I'm afraid there as been quite a bit of churn in this department, and
the patch doesn't apply any more.

Kim, any chance you could respin this patch on top of mainline?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
