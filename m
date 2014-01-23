Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaAWEpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 23:45:38 -0500
Received: from ozlabs.org ([203.10.76.45]:59737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbaAWEph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 23:45:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Michel Lespinasse <walken@google.com>,
        ego@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
In-Reply-To: <52DF8C59.1090702@linux.vnet.ibm.com>
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 23 Jan 2014 12:59:33 +1030
Message-ID: <87r47z2zxu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> On 01/22/2014 02:00 PM, Srivatsa S. Bhat wrote:
>> Hi Paul,

I find an old patch for register_allcpu_notifier(), but the "bool
replay_history" should be eliminated (always true): it's too weird.

Then we should get rid of register_cpu_notifier, or at least hide it.

Thanks,
Rusty.
