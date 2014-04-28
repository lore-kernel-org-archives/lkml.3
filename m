Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaD1LGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbaD1LGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:06:16 -0400
Message-ID: <535E361D.3050902@redhat.com>
Date: Mon, 28 Apr 2014 13:06:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>
CC: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/2] KVM: async_pf: use_mm/mm_users fixes
References: <20140421132543.GA13594@redhat.com>
In-Reply-To: <20140421132543.GA13594@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/04/2014 15:25, Oleg Nesterov ha scritto:
> Hello.
>
> Completely untested and I know nothing about kvm ;) Please review.
>
> But use_mm() really looks misleading, and the usage of mm_users looks
> "obviously wrong". I already sent this change while we were discussing
> vmacache, but it was ignored. Since then kvm_async_page_present_sync()
> was added into async_pf_execute() into async_pf_execute(), but it seems
> to me that use_mm() is still unnecessary.
>
> Oleg.
>
>  virt/kvm/async_pf.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>

Applying patch 2 to kvm/master (for 3.15).

Patch 1 will be for 3.16 only, I'd like a review from Marcelo or Andrea 
though (that's "KVM: async_pf: kill the unnecessary use_mm/unuse_mm 
async_pf_execute()" for easier googling).

Paolo
