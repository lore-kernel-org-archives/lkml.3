Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaKXSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:10:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64786 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbaKXSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:10:17 -0500
Message-ID: <54737485.1060405@arm.com>
Date: Mon, 24 Nov 2014 18:10:13 +0000
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org,
        john.liuli@huawei.com, ming.lei@canonical.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, gleb@kernel.org,
        alex.williamson@redhat.com, paulus@samba.org, pbonzini@redhat.com,
        feng.wu@intel.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] irqfd support for arm/arm64
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org> <20141124094731.GH3401@cbox> <54730426.9030703@linaro.org>
In-Reply-To: <54730426.9030703@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/11/14 10:10, Eric Auger wrote:
> On 11/24/2014 10:47 AM, Christoffer Dall wrote:
>> On Sun, Nov 23, 2014 at 06:56:57PM +0100, Eric Auger wrote:
>>> This patch series enables irqfd on arm and arm64.
>>>
>>> Irqfd framework enables to inject a virtual IRQ into a guest upon an
>>> eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
>>> a kvm_irqfd struct that associates a VM, an eventfd, a virtual IRQ number
>>> (aka. the gsi). When an actor signals the eventfd (typically a VFIO
>>> platform driver), the kvm irqfd subsystem injects the gsi into the VM.
>>>
>>> Resamplefd also is supported for level sensitive interrupts, ie. the
>>> user can provide another eventfd that is triggered when the completion
>>> of the virtual IRQ (gsi) is detected by the GIC.
>>>
>>> The gsi must correspond to a shared peripheral interrupt (SPI), ie the
>>> GIC interrupt ID is gsi + 32.
>>>
>>> The rationale behind not supporting PPI irqfd injection is that
>>> any device using a PPI would be a private-to-the-CPU device (timer for
>>> instance), so its state would have to be context-switched along with the
>>> VCPU and would require in-kernel wiring anyhow. It is not a relevant use
>>> case for irqfds.
>>>
>>> this patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
>>>
>>> No IRQ routing table is used, enabling to remove CONFIG_HAVE_KVM_IRQCHIP
>>>
>>> can be found at git://git.linaro.org/people/eric.auger/linux.git
>>> on branch irqfd_integ_v8
>>>
>>> This work was tested with Calxeda Midway xgmac main interrupt with
>>> qemu-system-arm and QEMU VFIO platform device. Also irqfd was proven
>>> functional on several vhost-net prototypes.
>>>
>>> v3 -> v4:
>>> - rebase on 3.18rc5
>>> - vgic dynamic instantiation brought new challenges:
>>>   handling of irqfd injection when vgic is not ready
>>> - unset of CONFIG_HAVE_KVM_IRQCHIP in a separate patch
>>> - add arm64 enable
>>> - vgic.c style modifications according to Christoffer comments
>>>
>>
>> There also seems to be a different split of the patches here?
> Hi Christoffer,
> yes I added arm64b support and moved CONFIG_HAVE_KVM_IRQCHIP removal in
> a separate patch.
>>
>> We've probably also reached the point where you need to start rebasing
>> on Andre's GICv3 patches, which I expect will go in first.
> the patch applies without conflict on Andre's series.

Yes, I can confirm this. I also manually checked the patches to spot any
fallouts due to the vgic.c file split, but Eric's patches are not
affected by this.

Cheers,
Andre.

> 
> BR
> 
> Eric
>>
>> Thanks,
>> -Christoffer
>>
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
