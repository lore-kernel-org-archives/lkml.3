Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaK1IuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:50:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:54790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaK1IuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:50:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,475,1413270000"; 
   d="scan'208";a="629552816"
Date: Fri, 28 Nov 2014 16:27:06 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Zhang Haoyu <zhanghy@sangfor.com>
Cc: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Gleb Natapov <gleb@cloudius-systems.com>, linux-kernel@vger.kernel.org
Subject: Re: [question] lots of interrupts injected to vm when pressing some
 key w/o releasing
Message-ID: <20141128082706.GA4090@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <201411201020560455720@sangfor.com>
 <201411242017440822890@sangfor.com>
 <547323A7.8050104@redhat.com>
 <201411250953587250205@sangfor.com>
 <54742995.7010209@redhat.com>
 <201411251920494491538@sangfor.com>
 <547489AA.3080509@redhat.com>
 <201411261511537876936@sangfor.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0ABF2A95@SHSMSX104.ccr.corp.intel.com>
 <201411271520408455055@sangfor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411271520408455055@sangfor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
On Thu, Nov 27, 2014 at 03:20:43PM +0800, Zhang Haoyu wrote:
>>>>>>> I tested win-server-2008 with "-cpu 
>>>>>>> core2duo,hv_spinlocks=0xffff,hv_relaxed,hv_time",
>>>>>>> this problem still happened, about 200,000 vmexits per-second, 
>>>>>>> bringing very bad experience, just like being stuck.
>>>>>> 
>>>>>> Please upload a full trace somewhere, or at least the "perf report" output.
>>>>>> 
>>>>> 
>>>>> And, if I remove the commit of 0bc830b0, the problem disappeared.
>>>> 
>>>> Please send the full trace file.  If you compress it, it should be small.
>>>> 
>>> See the attach 1, please.
>>> 
>>>> Paolo
>>
>>Can you try the follow draft patch to see whether it solve your problem? This patch is based on commit 0bc830b0.
>>
>After applying this patch, VM got stuck with black-screen at boot stage,
># trace-cmd report:
>version = 6
>CPU 0 is empty
>CPU 1 is empty
>CPU 2 is empty
>CPU 3 is empty
>CPU 5 is empty
>CPU 7 is empty
>cpus=8
>             kvm-1266  [004] 14399.834397: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [004] 14399.834403: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [004] 14399.834411: kvm_apic_accept_irq:  apicid 0 vec 177 (LowPrio|level)
>             kvm-1266  [004] 14399.834412: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [004] 14402.180013: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [004] 14402.180019: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [004] 14402.180028: kvm_apic_accept_irq:  apicid 1 vec 177 (LowPrio|level)
>             kvm-1266  [004] 14402.180029: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [004] 14404.525627: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [004] 14404.525634: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [004] 14404.525641: kvm_apic_accept_irq:  apicid 0 vec 177 (LowPrio|level)
>             kvm-1266  [004] 14404.525642: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [004] 14406.871238: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [004] 14406.871245: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [004] 14406.871254: kvm_apic_accept_irq:  apicid 1 vec 177 (LowPrio|level)
>             kvm-1266  [004] 14406.871256: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [006] 14409.216849: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [006] 14409.216855: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [006] 14409.216862: kvm_apic_accept_irq:  apicid 0 vec 177 (LowPrio|level)
>             kvm-1266  [006] 14409.216863: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [006] 14411.562475: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [006] 14411.562481: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [006] 14411.562489: kvm_apic_accept_irq:  apicid 1 vec 177 (LowPrio|level)
>             kvm-1266  [006] 14411.562491: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>             kvm-1266  [004] 14413.908074: kvm_set_irq:          gsi 9 level 1 source 0
>             kvm-1266  [004] 14413.908080: kvm_pic_set_irq:      chip 1 pin 1 (edge|masked)
>             kvm-1266  [004] 14413.908088: kvm_apic_accept_irq:  apicid 0 vec 177 (LowPrio|level)
>             kvm-1266  [004] 14413.908089: kvm_ioapic_set_irq:   pin 9 dst 3 vec=177 (LowPrio|logical|level)
>
>Thanks,
>Zhang Haoyu
>
>>diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
>>index 25e16a6..8f4e211 100644
>>--- a/virt/kvm/ioapic.c
>>+++ b/virt/kvm/ioapic.c
>>@@ -305,6 +305,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>>        return ret;
>> }
>> 
>>+static int irq_status[256];
>> int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>>                       int level, bool line_status)
>> {
>>@@ -312,10 +313,13 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>>        u32 mask = 1 << irq;
>>        union kvm_ioapic_redirect_entry entry;
>>        int ret, irq_level;
>>+       int old_irq;
>> 

I'm not sure which version of kvm the patch is against, anyway, all the 
modification should be moved to ioapic_set_irq() against the upstream 
kvm, I test the patch w/ win2k8 guest and w/o the Haoyu's comand line 
and it can fix the bug mentioned by Haoyu, in addition, press any key 
can reproduce the bug on my side instead of the small set which Haoyu 
mentioned.

Regards,
Wanpeng Li 

>>        BUG_ON(irq < 0 || irq >= IOAPIC_NUM_PINS);
>> 
>>        spin_lock(&ioapic->lock);
>>+       old_irq = irq_status[irq];
>>+       irq_status[irq] = level;
>>        old_irr = ioapic->irr;
>>        irq_level = __kvm_irq_line_state(&ioapic->irq_states[irq],
>>                                         irq_source_id, level);
>>@@ -332,6 +336,10 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>>                        goto out;
>>                }
>>                ioapic->irr |= mask;
>>+               if (edge && old_irq == irq_status[irq] && old_irq) {
>>+                       ret = 0;
>>+                       goto out;
>>+               }
>>                if ((edge && old_irr != ioapic->irr) ||
>>                    (!edge && !entry.fields.remote_irr))
>>                        ret = ioapic_service(ioapic, irq, line_status);
>>
>>Best regards,
>>Yang
>
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
