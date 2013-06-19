Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab3FSL1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:27:49 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37797 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934141Ab3FSL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:27:47 -0400
Message-ID: <51C195AC.80201@gmail.com>
Date: Wed, 19 Jun 2013 19:27:40 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130610075656.GY4725@redhat.com> <51B590C9.9080009@gmail.com> <20130610224352.0a769838745b294fc43f7823@gmail.com> <20130610170341.GJ29022@redhat.com> <51C1911A.3000507@redhat.com>
In-Reply-To: <51C1911A.3000507@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 07:08 PM, Paolo Bonzini wrote:
> Il 10/06/2013 19:03, Gleb Natapov ha scritto:
>> On Mon, Jun 10, 2013 at 10:43:52PM +0900, Takuya Yoshikawa wrote:
>>> On Mon, 10 Jun 2013 16:39:37 +0800
>>> Xiao Guangrong <xiaoguangrong.eric@gmail.com> wrote:
>>>
>>>> On 06/10/2013 03:56 PM, Gleb Natapov wrote:
>>>>> On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
>>>
>>>>> Looks good to me, but doesn't tis obsolete kvm_mmu_zap_mmio_sptes() and
>>>>> sp->mmio_cached, so they should be removed as part of the patch series?
>>>>
>>>> Yes, i agree, they should be removed. :)
>>>
>>> I'm fine with removing it but please make it clear that you all agree
>>> on the same basis.
>>>
>>> Last time, Paolo mentioned the possibility to use some bits of spte for
>>> other things.  The suggestion there was to keep sp->mmio_cached code
>>> for the time we would need to reduce the bits for generation numbers.
>>>
>>> Do you think that zap_all() is now preemptible and can treat the
>>> situation reasonably well as the current kvm_mmu_zap_mmio_sptes()?
>>>
>>> One downside is the need to zap unrelated shadow pages, but if this case
>>> is really very rare, yes I agree, it should not be a problem: it depends
>>> on how many bits we can use.
>>>
>>> Just please reconfirm.
>>>
>> That was me who mention the possibility to use some bits of spte for
>> other things. But for now I have a use for one bit only. Now that you
>> have reminded me about that discussion I am not so sure we want to
>> remove kvm_mmu_zap_mmio_sptes(), but on the other hand it is non
>> preemptable, so large number of mmio sptes can cause soft lockups.
>> zap_all() is better in this regards now.
> 
> I asked Gleb on IRC, and he's fine with applying patch 7 too (otherwise
> there's hardly any benefit, because kvm_mmu_zap_mmio_sptes is
> non-preemptable).
> 
> I'm also changing the -13 to -150 since it's quite easy to generate 150
> calls to KVM_SET_USER_MEMORY_REGION.  Using QEMU, and for a pretty basic
> guest with virtio-net, IDE controller and VGA you get:
> 
> - 9-10 calls before starting the guest, depending on the guest memory size
> 
> - around 25 during the BIOS
> 
> - around 20 during kernel boot
> 
> - 34 during a single dump of the 64 KB ROM from a virtio-net device.

Okay. The change is find to me. :)


