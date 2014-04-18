Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaDRIeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:34:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59045 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:33:56 -0400
Date: Fri, 18 Apr 2014 10:33:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 06/19] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140418083342.GA11096@twins.programming.kicks-ass.net>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <1397747051-15401-7-git-send-email-Waiman.Long@hp.com>
 <20140417163640.GT11096@twins.programming.kicks-ass.net>
 <535083DC.2040406@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535083DC.2040406@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:46:04PM -0400, Waiman Long wrote:
> BTW, I didn't test out your atomic_test_and_set() change. Did it provide a
> noticeable performance benefit when compared with cmpxchg()?

I've not tested that I think. I had a hard time showing that cmpxchg
loops were slower, but once I did, I simply replaced all cmpxchg loops
with unconditional ops where possible.

The machine that was big enough to show it lived in a lab half way
around the world and using it was a right pain in the ass, so I didn't
use it more than I absolutely had to.
