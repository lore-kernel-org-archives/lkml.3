Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3CESYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:24:45 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49300 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab3CESYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:24:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130305174204.GB5012@redhat.com>
References: <1362449845-7492-1-git-send-email-walken@google.com>
	<1362449845-7492-3-git-send-email-walken@google.com>
	<20130305174204.GB5012@redhat.com>
Date: Tue, 5 Mar 2013 10:24:42 -0800
Message-ID: <CANN689Eyro_0L-oAHrZ8GC-Pq4PCFXGSZTxrHpVzjfFXz305-w@mail.gmail.com>
Subject: Re: [PATCH 2/2] lglock: update lockdep annotations to report
 recursive local locks
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 9:42 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/04, Michel Lespinasse wrote:
>>
>> Both issues are easily fixed by indicating to lockdep that lglock's local
>> locks are not recursive. We shouldn't use the rwlock acquire/release
>> functions here, as lglock doesn't share the same semantics. Instead
>> we can base our lockdep annotations on the lock_acquire_shared
>> (for local lglock) and lock_acquire_exclusive (for global lglock)
>> helpers.
>
> IOW, with this patch lglock looks like rw_semaphore for lockdep...

Yes.

I could have actually made lglock use the rwsem helpers, but I think
that would be quite confusing...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
