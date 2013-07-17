Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab3GQS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:56:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab3GQS4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:56:10 -0400
Date: Wed, 17 Jul 2013 21:55:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes)
 causes hang
Message-ID: <20130717185539.GK13732@redhat.com>
References: <20130717163215.GA359@x4>
 <20130717164232.GI13732@redhat.com>
 <20130717165743.GA357@x4>
 <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
 <20130717184226.GA358@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717184226.GA358@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 08:42:26PM +0200, Markus Trippelsdorf wrote:
> On 2013.07.18 at 01:25 +0800, Xiao Guangrong wrote:
> > Hi Markus,
> > 
> > Thanks for your report! I am downloading the ubuntu iso and will try to reproducible it.
> > 
> > Could you please enable these tracepoints:
> > kvmmmu/check_mmio_spte
> > kvmmmu/handle_mmio_page_fault
> > kvmmmu/kvm_mmu_invalidate_zap_all_pages
> > kvmmmu/mark_mmio_spte
> > kvm/kvm_mmio
> > kvm/vcpu_match_mmio
> > 
> > and post the output?
> > 
> First line repeated ad nauseam.
> ...
> 10346367  qemu-system-x86-1403  [001]  1451.422225: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346368  qemu-system-x86-1403  [001]  1451.422226: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346369  qemu-system-x86-1403  [001]  1451.422227: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346370  qemu-system-x86-1403  [001]  1451.422228: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346371  qemu-system-x86-1403  [001]  1451.422229: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346372  qemu-system-x86-1404  [002]  1451.422229: kvm_mmio:             mmio write len 4 gpa 0xfee000b0 val 0x0
> 10346373  qemu-system-x86-1403  [001]  1451.422230: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346374  qemu-system-x86-1403  [001]  1451.422231: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346375  qemu-system-x86-1403  [001]  1451.422232: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346376  qemu-system-x86-1403  [001]  1451.422233: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346377  qemu-system-x86-1403  [001]  1451.422234: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346378  qemu-system-x86-1403  [001]  1451.422235: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346379  qemu-system-x86-1404  [002]  1451.422236: kvm_mmio:             mmio write len 4 gpa 0xfee00380 val 0x3c7b0
> 10346380  qemu-system-x86-1403  [001]  1451.422237: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346381  qemu-system-x86-1403  [001]  1451.422238: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346382  qemu-system-x86-1403  [001]  1451.422239: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346383  qemu-system-x86-1403  [001]  1451.422240: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346384  qemu-system-x86-1403  [001]  1451.422241: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346385  qemu-system-x86-1403  [001]  1451.422242: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346386  qemu-system-x86-1403  [001]  1451.422243: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346387  qemu-system-x86-1403  [001]  1451.422244: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0
> 10346403  qemu-system-x86-1403  [001]  1451.422260: check_mmio_spte:      spte ffff0000fee00e3f kvm_gen 7ffc8 spte-gen 7ffc7 valid 0  
> ...
> Last line repeated ad nauseam.
> 
While this happens can you run "echo t > /proc/sysrq-trigger" and attach
dmesg here.

--
			Gleb.
