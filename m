Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaD1P1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:27:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbaD1P1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:27:35 -0400
Message-ID: <535E734E.3020307@redhat.com>
Date: Mon, 28 Apr 2014 17:27:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/2] KVM: async_pf: change async_pf_execute() to use get_user_pages(tsk
 => NULL)
References: <20140421132543.GA13594@redhat.com> <535E361D.3050902@redhat.com> <20140428141532.GD10488@redhat.com> <20140428150234.GA19879@redhat.com> <20140428150300.GB19879@redhat.com>
In-Reply-To: <20140428150300.GB19879@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/04/2014 17:03, Oleg Nesterov ha scritto:
> async_pf_execute() passes tsk == current to gup(), this is doesn't
> hurt but unnecessary and misleading. "tsk" is only used to account
> the number of faults and current is the random workqueue thread.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  virt/kvm/async_pf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 0ced4f3..62f4223 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -81,7 +81,7 @@ static void async_pf_execute(struct work_struct *work)
>  	might_sleep();
>
>  	down_read(&mm->mmap_sem);
> -	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
> +	get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
>  	up_read(&mm->mmap_sem);
>  	kvm_async_page_present_sync(vcpu, apf);
>
>

Thanks, added a Suggested-by for Andrea and applied together with 1/2 to 
kvm/queue.

(Actually, I'm back from a longish vacation and I have a pretty large 
queue, so I haven't even compile tested these for now.  Once I get round 
to at least smoke-test them, I'll really push to kvm/queue).

Paolo
