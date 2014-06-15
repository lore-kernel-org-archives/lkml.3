Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaFONOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:14:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:41617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFONOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:14:19 -0400
Date: Sun, 15 Jun 2014 15:14:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
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
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 09/16] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
Message-ID: <20140615131416.GI11371@laptop.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-10-git-send-email-Waiman.Long@hp.com>
 <20140611105402.GL3213@twins.programming.kicks-ass.net>
 <53990473.7020802@hp.com>
 <20140612055016.GP6758@twins.programming.kicks-ass.net>
 <539A16CC.6040104@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A16CC.6040104@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 05:08:28PM -0400, Waiman Long wrote:
> >Native performance is king, try your very utmost bestest to preserve
> >that, paravirt is a distant second and nobody sane should care about the
> >virt case at all.
> 
> The patch won't affect native performance unless the kernel is built with
> VIRT_UNFAIR_LOCKS selected. The same is also true when PARAVIRT_SPINLOCKS is
> selected. There is no way around that.

VIRT_UNFAIR_LOCKS is an impossible switch to have; a distro cannot make
the right choice.

> I do agree that I may over-engineer on this patch,

Simple things first, then add complexity.
