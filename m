Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079AbaFQVAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:00:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43624 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905AbaFQVAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:00:12 -0400
Date: Tue, 17 Jun 2014 16:59:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v11 14/16] pvqspinlock: Add qspinlock para-virtualization
 support
Message-ID: <20140617205915.GC29634@laptop.dumpdata.com>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-15-git-send-email-Waiman.Long@hp.com>
 <20140612081731.GM3213@twins.programming.kicks-ass.net>
 <539A1229.1050309@hp.com>
 <20140615131654.GJ11371@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615131654.GJ11371@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 03:16:54PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 12, 2014 at 04:48:41PM -0400, Waiman Long wrote:
> > I don't have a good understanding of the kernel alternatives mechanism.
> 
> I didn't either; I do now, cost me a whole day reading up on
> alternative/paravirt code patching.
> 
> See the patches I just send out; I got the 'native' case with paravirt
> enabled to be one NOP worse than the native case without paravirt -- for
> queue_spin_unlock.
> 
> The lock slowpath is several nops and some pointless movs more expensive.

You could use the asm goto which would optimize the fast path to be the
'native' case. That way you wouldn't have the the nops and movs in the
path.

(And asm goto also uses the alternative_asm macros).
