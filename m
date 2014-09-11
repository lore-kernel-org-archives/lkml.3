Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaIKN04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:26:56 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46870 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaIKN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:26:54 -0400
Date: Thu, 11 Sep 2014 06:25:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Chintan Pandya <cpandya@codeaurora.org>
cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers
 for scanner thread
In-Reply-To: <541156C9.1080203@codeaurora.org>
Message-ID: <alpine.LSU.2.11.1409110609320.2465@eggly.anvils>
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org> <1408536628-29379-2-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408272258050.10518@eggly.anvils> <20140903095815.GK4783@worktop.ger.corp.intel.com>
 <alpine.LSU.2.11.1409080023100.1610@eggly.anvils> <20140908093949.GZ6758@twins.programming.kicks-ass.net> <alpine.LSU.2.11.1409091225310.8432@eggly.anvils> <541156C9.1080203@codeaurora.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Chintan Pandya wrote:

> I don't mean to divert the thread too much. But just one suggestion offered
> by Harshad.
> 
> Why can't we stop invoking more of a KSM scanner thread when we are
> saturating from savings ? But again, to check whether savings are saturated
> or not, we may still want to rely upon timers and we have to wake the CPUs up
> from IDLE state.

I agree that it should make sense for KSM to slow down when it sees it's
making no progress (though that would depart from the pages_to_scan and
sleep_millisecs prescription - perhaps could be tied to sleep_millisecs 0).

But not stop.  That's the problem we're mainly concerned with here:
to save power we need it to stop, but then how to wake up, without
putting nasty hooks in hot paths for a minority interest?
I don't see an answer to that above.

Hugh
