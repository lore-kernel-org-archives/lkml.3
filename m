Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966361AbaFRLnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965572AbaFRLnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:43:14 -0400
Message-ID: <53A17B15.3080904@redhat.com>
Date: Wed, 18 Jun 2014 13:42:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Waiman.Long@hp.com,
        tglx@linutronix.de, mingo@kernel.org
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/11] qspinlock: Optimize pending bit
References: <20140615124657.264658593@chello.nl> <20140615130153.638054585@chello.nl>
In-Reply-To: <20140615130153.638054585@chello.nl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/06/2014 14:47, Peter Zijlstra ha scritto:
> XXX: merge into the pending bit patch..

Agree, or if not move it right after the pending bit patch, before the 
NR_CPUS optimization.

Paolo

> It is possible so observe the pending bit without the locked bit when
> the last owner has just released but the pending owner has not yet
> taken ownership.
>
> In this case we would normally queue -- because the pending bit is
> already taken. However, in this case the pending bit is guaranteed to
> be released 'soon', therefore wait for it and avoid queueing.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

