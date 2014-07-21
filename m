Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbaGUQq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:46:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:23782 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543AbaGUQq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,702,1400050800"; 
   d="scan'208";a="573162484"
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	<8761iq3bp3.fsf@tassilo.jf.intel.com>
Date: Mon, 21 Jul 2014 09:45:55 -0700
In-Reply-To: <8761iq3bp3.fsf@tassilo.jf.intel.com> (Andi Kleen's message of
	"Mon, 21 Jul 2014 09:42:48 -0700")
Message-ID: <871tte3bjw.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Waiman Long <Waiman.Long@hp.com> writes:
>
>> This patch series introduces two new futex command codes to support
>> a new optimistic spinning futex for implementing an exclusive lock
>> primitive that should perform better than the same primitive using
>> the wait-wake futex in cases where the lock owner is actively working
>> instead of waiting for I/O completion.
>
> How would you distinguish those two cases automatically?

Also BTW traditionally the spinning was just done in user space.

This would be always even more efficient, because it would 
even avoid the syscall entry path.

Given the glibc adaptive mutexes are not very good, but I'm sure those
could be improved.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
