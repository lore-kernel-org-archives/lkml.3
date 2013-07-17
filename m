Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3GQR0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:26:17 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46858 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3GQR0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:26:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes) causes hang
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130717165743.GA357@x4>
Date: Thu, 18 Jul 2013 01:25:11 +0800
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
References: <20130717163215.GA359@x4> <20130717164232.GI13732@redhat.com> <20130717165743.GA357@x4>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

Thanks for your report! I am downloading the ubuntu iso and will try to reproducible it.

Could you please enable these tracepoints:
kvmmmu/check_mmio_spte
kvmmmu/handle_mmio_page_fault
kvmmmu/kvm_mmu_invalidate_zap_all_pages
kvmmmu/mark_mmio_spte
kvm/kvm_mmio
kvm/vcpu_match_mmio

and post the output?

Just check, your host is 64-bit or 32 bit? 

On Jul 18, 2013, at 12:57 AM, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2013.07.17 at 19:42 +0300, Gleb Natapov wrote:
>> On Wed, Jul 17, 2013 at 06:32:15PM +0200, Markus Trippelsdorf wrote:
>>> The following commit:
>>> commit f8f559422b6c6a05469dfde614b67789b6142cb5
>>> Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>> Date:   Fri Jun 7 16:51:26 2013 +0800
>>> 
>>>    KVM: MMU: fast invalidate all mmio sptes
>>> 
>>> causes my kvm qemu qcow2 images to hang when they switch from the boot
>>> console to the desktop. For example:
>>> qemu-system-x86_64 -enable-kvm -net nic,vlan=0,model=virtio -net user -drive file=ubuntu,if=virtio,cache=unsafe -smp 2 -m 1024
>>> boots normally at first, but then hangs as soon as Xorg gets started.`
>>> 
>> Which guest is is exactly and how reproducible is this?
> 
> Ubuntu 12.04.
> It's 100% reproducible or else it wouldn't have been so easily
> bisectable.
> 
>>> Perf top shows:
>>> 20.99%  [kernel]                                  [k] svm_vcpu_run
>>> 17.24%  [kernel]                                  [k] handle_mmio_page_fault_common
>>> 15.61%  [kernel]                                  [k] kvm_arch_vcpu_ioctl_run
>>> 12.49%  [kernel]                                  [k] fast_page_fault.part.78
>>> 
>>> I'm running:
>>> QEMU emulator version 1.4.2 
>>> on an AMD PhenomII X4 CPU.
>>> 
>> What is the output of "cat /proc/cpuinfo"?
> 
> 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 16
> model		: 4
> model name	: AMD Phenom(tm) II X4 955 Processor
> stepping	: 2
> microcode	: 0x10000db
> cpu MHz		: 800.000
> cache size	: 512 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 4
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 5
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
> bogomips	: 6424.73
> TLB size	: 1024 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
> ...
> *4
> 
> -- 
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

