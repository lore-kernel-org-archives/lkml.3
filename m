Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3IWNfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:35:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:36694 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3IWNfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:35:31 -0400
Message-ID: <524043C5.70700@windriver.com>
Date: Mon, 23 Sep 2013 09:36:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <20130922074238.GG25202@redhat.com> <523EAFFA.6060203@redhat.com> <20130922095348.GJ25202@redhat.com>
In-Reply-To: <20130922095348.GJ25202@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-22 05:53 AM, Gleb Natapov wrote:
> On Sun, Sep 22, 2013 at 10:53:14AM +0200, Paolo Bonzini wrote:
>> Il 22/09/2013 09:42, Gleb Natapov ha scritto:
>>> On Mon, Sep 16, 2013 at 04:06:10PM +0200, Paolo Bonzini wrote:
>>>> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
>>>> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
>>>> patch that shrunk the kvm_lock critical section so that the mmu_lock
>>>> critical section does not nest with it, but in the end there is no reason
>>>> for the vm_list to be protected by a raw spinlock.  Only manipulations
>>>> of kvm_usage_count and the consequent hardware_enable/disable operations
>>>> are not preemptable.
>>>>
>>>> This small series thus splits the kvm_lock in the "raw" part and the
>>>> "non-raw" part.
>>>>
>>>> Paul, could you please provide your Tested-by?
>>>>
>>> Reviewed-by: Gleb Natapov <gleb@redhat.com>
>>>
>>> But why should it go to stable?
>>
>> It is a regression from before the kvm_lock was made raw.  Secondarily,
> It was made raw in 2.6.39 and commit message claims that it is done for
> -rt sake, why regression was noticed only now?
> 
>> it takes a much longer time before a patch hits -rt trees (can even be
>> as much as a year) and this patch does nothing on non-rt trees.  So
>> without putting it into stable it would get no actual coverage.
>>
> The change is not completely trivial, it splits lock. There is no
> obvious problem of course, otherwise you wouldn't send it and I
> would ack it :), but it does not mean that the chance for problem is
> zero, so why risk stability of stable even a little bit if the patch
> does not fix anything in stable?
> 
> I do not know how -rt development goes and how it affects decisions for
> stable acceptance, why can't they carry the patch in their tree until
> they move to 3.12?

The -rt tree regularly carries mainline backports that are of interest
to -rt but perhaps not of interest to stable, so there is no problem
doing the same with content like this, if desired.

Thanks,
Paul.
--

> 
> --
> 			Gleb.
> 
