Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaIKRrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaIKRrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:47:12 -0400
Date: Thu, 11 Sep 2014 18:44:09 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "jcastillo@redhat.com" <jcastillo@redhat.com>,
        "riel@redhat.com" <riel@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mingo@kernel.com" <mingo@kernel.com>,
        "bmr@redhat.com" <bmr@redhat.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "akpm@google.com" <akpm@google.com>, "jgh@redhat.com" <jgh@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pzijlstr@redhat.com" <pzijlstr@redhat.com>
Subject: Re: [PATCH v3 0/3] sched: Always check the integrity of the canary
Message-ID: <20140911174408.GA1873@atomlin.usersys.redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D17490245@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17490245@AcuExch.aculab.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:02:45PM +0000, David Laight wrote:
> From: Aaron Tomlin
> > Currently in the event of a stack overrun a call to schedule()
> > does not check for this type of corruption. This corruption is
> > often silent and can go unnoticed. However once the corrupted
> > region is examined at a later stage, the outcome is undefined
> > and often results in a sporadic page fault which cannot be
> > handled.
> > 
> > The first patch adds a canary to init_task's end of stack.
> > While the second patch provides a helper to determine the
> > integrity of the canary. The third checks for a stack
> > overrun and takes appropriate action since the damage
> > is already done, there is no point in continuing.
> 
> Clearly you've just been 'bitten' by a kernel stack overflow.
> But a simple 'canary' isn't going to find most of the overflows
> and will give an incorrect 'sense of security'.

Please note that this is not suppose to be a 'perfect' solution.
Rather a worth while check in this particular code path.
Let's assume that the canary is damaged. In this situation it is
rather likely that the thread_info object has been compromised too.

-- 
Aaron Tomlin
