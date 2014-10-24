Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaJXI5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:57:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaJXI5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:57:11 -0400
Date: Fri, 24 Oct 2014 10:57:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 00/11] qspinlock: a 4-byte queue spinlock with PV
 support
Message-ID: <20141024085659.GW21513@worktop.programming.kicks-ass.net>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:10:29PM -0400, Waiman Long wrote:
> v11->v12:
>  - Based on PeterZ's version of the qspinlock patch
>    (https://lkml.org/lkml/2014/6/15/63).
>  - Incorporated many of the review comments from Konrad Wilk and
>    Paolo Bonzini.
>  - The pvqspinlock code is largely from my previous version with
>    PeterZ's way of going from queue tail to head and his idea of
>    using callee saved calls to KVM and XEN codes.

Thanks for taking the time to refresh this.. I would prefer you use a
little more of the PV techniques I outlined in my latest PV patch to
further reduce the overhead of PV enabled kernels on real hardware.

This is an important use case, because distro kernels will have to
enable PV support while their majority of installations will be on
physical hardware.

Other than that I see no reason not to move this forward.
