Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3JXXVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 19:21:03 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10716 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3JXXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 19:21:00 -0400
Message-ID: <5269AB47.4000007@hp.com>
Date: Thu, 24 Oct 2013 19:20:39 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v8 10/10] MCS Lock: Make mcs_spinlock.h includable in
 other files
References: <1382644912-16458-1-git-send-email-Waiman.Long@hp.com> <1382648315.11046.224.camel@schen9-DESK>
In-Reply-To: <1382648315.11046.224.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 04:58 PM, Tim Chen wrote:
>
> Do we want to inline the unlock?  Will that prevent proper profile
> accounting of unlock overhead?
>
> Can we keep the mcs_spin_unlock and mcs_spin_lock in the same
> kernel/mcs_spinlock.c file? That makes it easier to read and
> maintain the code.

The unlock code is fast. The lock code, however, can run for a long 
time. It will greatly increase the reported time spent in the calling 
function if it is inlined. The same is true for spinlock. The 
_raw_spin_lock() is a real function while _raw_spin_unlock() is inlined 
in most cases.

Yes, I can bring the lock function back to the mcs_spinlock.h file with 
name like _raw_mcs_spin_lock() and the mcs_spin_lock() in mcs_spinlock.c 
will include the raw function. In that way, the mcs_spin_lock() will 
still be a separate function while both the lock and unlock code will be 
together.

> Can you check if you have applied all the previous MCS patches?
> The last two for barrier corrections and optimizations seem
> to be missing.
>
> MCS Lock: optimizations and extra comments
> https://lkml.org/lkml/2013/10/2/644
> MCS Lock: Barrier corrections
> https://lkml.org/lkml/2013/10/2/650
>
> Thanks.
>
> Tim
>

Apparently, I does have all the MCS patch  in my git tree. I will 
regenerate a new one with the right diff. Thank for the review.

-Longman
