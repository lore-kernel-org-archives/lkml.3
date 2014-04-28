Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaD1Pbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaD1Pbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:31:40 -0400
Message-ID: <535E744A.1060708@redhat.com>
Date: Mon, 28 Apr 2014 17:31:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async_pf: kill the unnecessary use_mm/unuse_mm
 async_pf_execute()
References: <20140421132558.GA13608@redhat.com> <5356CDDF.5000203@de.ibm.com> <5356DA2F.8080606@de.ibm.com> <20140423193228.GA3441@redhat.com> <20140428140602.GC10488@redhat.com>
In-Reply-To: <20140428140602.GC10488@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/04/2014 16:06, Andrea Arcangeli ha scritto:
>> >
>> > "task" is only used to increment task_struct->xxx_flt. I don't think
>> > async_pf_execute() actually needs this (current is PF_WQ_WORKER after
>> > all), but I didn't dare to do another change in the code I can hardly
>> > understand.
> Considering the faults would be randomly distributed among the kworker
> threads my preference would also be for NULL instead of current.
>
> ptrace and uprobes tends to be the only two places that look into
> other mm with gup, ptrace knows the exact pid that it is triggering
> the fault into, so it also can specify the correct task so the fault
> goes in the right task struct. uprobes uses NULL.

KVM knows the correct task (it was in current when kvm_create_vm was 
called), and doing accounting right would be nice.  But I agree that 
NULL is less misleading than a dummy current, and I applied patch 3 too.

Paolo
