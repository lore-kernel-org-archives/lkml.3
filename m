Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3GOGAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:00:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39371 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3GOGAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:00:47 -0400
Message-ID: <51E390D5.3000707@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:34:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 18/18] kvm hypervisor: Add directed yield in vcpu
 block path
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124415.27508.74230.sendpatchset@codeblue.in.ibm.com> <20130714141818.GD11772@redhat.com>
In-Reply-To: <20130714141818.GD11772@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071505-1396-0000-0000-000003423760
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 07:48 PM, Gleb Natapov wrote:
> On Mon, Jun 24, 2013 at 06:14:15PM +0530, Raghavendra K T wrote:
>> kvm hypervisor: Add directed yield in vcpu block path
>>
>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>
>> We use the improved PLE handler logic in vcpu block patch for
>> scheduling rather than plain schedule, so that we can make
>> intelligent decisions.
>>
> What kind of improvement this provides? Doesn't it screw up our pause
> exit heuristics?

No. it does not affect negatively from what I saw. ( and even from
results).

So it will make ple handler to avoid yield_to to those vcpus,
still looping in  halt handler.
May be vcpus which are pv_unhalted but not running, may miss this.
but haven't seen anything bad happening with that.
But yes, planning to do some experiments around this. Thanks for
bringing this up.

Between another good point about this is, though non PLE hardwares are
becoming obsolete, they can potentially take the advantage of PLE
handler.

>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   arch/ia64/include/asm/kvm_host.h    |    5 +++++
>>   arch/powerpc/include/asm/kvm_host.h |    5 +++++
>>   arch/s390/include/asm/kvm_host.h    |    5 +++++
>>   arch/x86/include/asm/kvm_host.h     |    2 +-
>>   arch/x86/kvm/x86.c                  |    8 ++++++++
>>   include/linux/kvm_host.h            |    2 +-
>>   virt/kvm/kvm_main.c                 |    6 ++++--
> This miss some arches.

Thanks for pointing that. arm and mips were not around at V8 time, I 
missed them.

