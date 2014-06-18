Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaFRS3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:29:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaFRS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:29:03 -0400
Date: Wed, 18 Jun 2014 12:02:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/11] qspinlock: Extract out the exchange of tail code
 word
Message-ID: <20140618160232.GB5107@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.376621956@chello.nl>
 <20140617205525.GB29634@laptop.dumpdata.com>
 <53A17A09.6010007@redhat.com>
 <20140618135057.GB4729@laptop.dumpdata.com>
 <53A1B43C.8000009@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1B43C.8000009@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>However, I *do* agree with you that it's simpler to just squash this patch
> >>into 01/11.
> >Uh, did I say that? Oh I said why don't make it right the first time!
> >
> >I meant in terms of seperating the slowpath (aka the bytelock on the pending
> >bit) from the queue (MCS code). Or renaming the function to be called
> >'complex' instead of 'slowpath' as it is getting quite hairy.
> >
> >The #1 patch is nice by itself - as it lays out the foundation of the
> >MCS-similar code - and if Ingo decides he does not want this pending
> >byte-lock bit business - it can be easily reverted or dropped.
> 
> The pending bit code is needed for performance parity with ticket spinlock
> for light load. My own measurement indicates that the queuing overhead will
> cause the queue spinlock to be slower than ticket spinlock with 2-4
> contending tasks. The pending bit solves the performance problem with 2

Aha!

> contending tasks, leave only the 3-4 tasks cases being a bit slower than the
> ticket spinlock which should be more than compensated by its superior
> performance with heavy contention and slightly better performance with no
> contention.

That should be mentioned in the commit description as the rationale for
the patch "qspinlock: Add pending bit" and also in the code.

Thank you!
