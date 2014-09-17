Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaIQJPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbaIQJPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:15:14 -0400
Message-ID: <5419510E.2090404@redhat.com>
Date: Wed, 17 Sep 2014 11:14:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/6] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com> <1410864122-12434-5-git-send-email-tangchen@cn.fujitsu.com> <54181DE1.3040502@redhat.com> <541942B5.6000907@cn.fujitsu.com>
In-Reply-To: <541942B5.6000907@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/09/2014 10:13, Tang Chen ha scritto:
> 
> 
>> Please add a new function kvm_arch_mmu_notifier_invalidate_page, and
>> call it outside the mmu_lock.
> 
> Then I think we need a macro to control the calling of this arch function
> since other architectures do not have it.

You can add an inline function that does nothing.  There are other examples.

>> kvm_reload_apic_access_page need not be in virt/kvm/kvm_main.c, either.
> 
> Since kvm_reload_apic_access_page() only calls make_all_cpus_request(),
> and make_all_cpus_request() is static, I'd like to make it non-static, rename
> it to kvm_make_all_cpus_request() and call it directly in kvm_arch_mmu_notifier_invalidate_page().
> we don't need kvm_reload_apic_access_page() actually.

Ok.

Paolo
