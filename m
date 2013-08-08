Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966720Ab3HHVVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:21:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966648Ab3HHVVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:21:53 -0400
Message-ID: <52040A05.5080107@zytor.com>
Date: Thu, 08 Aug 2013 14:13:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, mingo@redhat.com,
        jeremy@goop.org, x86@kernel.org, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com> <52016412.1020608@zytor.com> <5201B6FB.5080807@linux.vnet.ibm.com> <5201D180.9080005@zytor.com> <5201ED01.7000803@linux.vnet.ibm.com> <20130808005012.GI2810@phenom.dumpdata.com> <20130808010251.GJ15901@redhat.com>
In-Reply-To: <20130808010251.GJ15901@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:02 PM, Gleb Natapov wrote:
> On Wed, Aug 07, 2013 at 08:50:12PM -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Aug 07, 2013 at 12:15:21PM +0530, Raghavendra K T wrote:
>>> On 08/07/2013 10:18 AM, H. Peter Anvin wrote:
>>>>> Please let me know, if I should rebase again.
>>>>>
>>>>
>>>> tip:master is not a stable branch; it is more like linux-next.  We need
>>>> to figure out which topic branches are dependencies for this set.
>>>
>>> Okay. I 'll start looking at the branches that would get affected.
>>> (Xen, kvm are obvious ones).
>>> Please do let me know the branches I might have to check for.
>>
>> >From the Xen standpoint anything past v3.11-rc4 would work.
>>
> For KVM as early as past v3.11-rc1 would be OK.
> 

I'm still completely confused as to the base of this patchset.  The
first patch has the following hunk for arch/x86/include/asm/paravirt.h:


--- arch/x86/include/asm/paravirt.h
+++ arch/x86/include/asm/paravirt.h
@@ -718,7 +718,7 @@
        PVOP_VCALLEE2(pv_lock_ops.lock_spinning, lock, ticket);
 }

-static __always_inline void ____ticket_unlock_kick(struct arch_spinlock
*lock,
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock
*lock,
                                                        __ticket_t ticket)
 {
        PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);


However, there is no ticket_unlock_kick in paravirt.h in either
tip:master nor in linus...

	-hpa



