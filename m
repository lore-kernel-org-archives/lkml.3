Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaGGQLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaGGQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:11:32 -0400
Message-ID: <53BAC676.5030804@redhat.com>
Date: Mon, 07 Jul 2014 18:10:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 05/11] qspinlock: Optimize for smaller NR_CPUS
References: <20140615124657.264658593@chello.nl> <20140615130153.483502389@chello.nl> <53A17A88.7090705@redhat.com> <20140707143503.GS6758@twins.programming.kicks-ass.net> <53BAB7E1.4010506@redhat.com> <20140707153552.GE19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140707153552.GE19379@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 17:35, Peter Zijlstra ha scritto:
>> > Unlike the change in patch 4, clear_pending_set_locked doesn't change how
>> > qspinlock moves from a state to the next.
> True, but its where we start to break up into smaller functions. And the
> only reason we break them out is because we'll get different
> implementations depending on NR_CPUS.
>
> So we can view the breakout of xchg_tail and clear_and_set_pending as
> preparatory work for introducing the NR_CPUS thing.

That's a different reasoning, but it's fine by me too.

Paolo
