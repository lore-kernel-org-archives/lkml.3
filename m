Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3IVIxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:53:03 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49490 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3IVIxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:53:00 -0400
Message-ID: <523EAFFA.6060203@redhat.com>
Date: Sun, 22 Sep 2013 10:53:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <20130922074238.GG25202@redhat.com>
In-Reply-To: <20130922074238.GG25202@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2013 09:42, Gleb Natapov ha scritto:
> On Mon, Sep 16, 2013 at 04:06:10PM +0200, Paolo Bonzini wrote:
>> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
>> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
>> patch that shrunk the kvm_lock critical section so that the mmu_lock
>> critical section does not nest with it, but in the end there is no reason
>> for the vm_list to be protected by a raw spinlock.  Only manipulations
>> of kvm_usage_count and the consequent hardware_enable/disable operations
>> are not preemptable.
>>
>> This small series thus splits the kvm_lock in the "raw" part and the
>> "non-raw" part.
>>
>> Paul, could you please provide your Tested-by?
>>
> Reviewed-by: Gleb Natapov <gleb@redhat.com>
> 
> But why should it go to stable?

It is a regression from before the kvm_lock was made raw.  Secondarily,
it takes a much longer time before a patch hits -rt trees (can even be
as much as a year) and this patch does nothing on non-rt trees.  So
without putting it into stable it would get no actual coverage.

Paolo
