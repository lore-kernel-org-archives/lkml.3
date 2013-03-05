Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3CERoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:44:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3CERoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:44:04 -0500
Date: Tue, 5 Mar 2013 18:42:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] lglock: update lockdep annotations to report
	recursive local locks
Message-ID: <20130305174204.GB5012@redhat.com>
References: <1362449845-7492-1-git-send-email-walken@google.com> <1362449845-7492-3-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362449845-7492-3-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Michel Lespinasse wrote:
>
> Both issues are easily fixed by indicating to lockdep that lglock's local
> locks are not recursive. We shouldn't use the rwlock acquire/release
> functions here, as lglock doesn't share the same semantics. Instead
> we can base our lockdep annotations on the lock_acquire_shared
> (for local lglock) and lock_acquire_exclusive (for global lglock)
> helpers.

IOW, with this patch lglock looks like rw_semaphore for lockdep...

Again, I can't ack this change, but afaics it is fine.

Oleg.

