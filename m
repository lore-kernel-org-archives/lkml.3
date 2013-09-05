Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3IEPKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:10:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54702 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3IEPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:10:36 -0400
Date: Thu, 5 Sep 2013 17:10:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, acme@infradead.org, jolsa@redhat.com,
        eranian@google.com
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
Message-ID: <20130905151034.GP19750@two.firstfloor.org>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <20130902065512.GA29060@gmail.com>
 <20130905131502.GA26387@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905131502.GA26387@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:15:02PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > One thing I'm not seeing in the current Haswell code is the config set 
> > up for PERF_COUNT_HW_STALLED_CYCLES_FRONTEND/BACKEND. Both SB and IB has 
> > them configured.
> 
> Ping? Consider this a regression report.

AFAIK they don't work. You only get the correct answer
in some situations, but in others it either overestimates
frontend or underestimates backend badly.

The correct way is to implement it like TopDown level 1,
but I don't know how to put that into the kernel.

http://software.intel.com/en-us/articles/how-to-tune-applications-using-a-top-down-characterization-of-microarchitectural-issues

It requires running 4 counters and computing some equations.

My toplev tool in http://github.com/andikleen/pmu-tools
has a implementation on top of perf.

I could put it into perf stat if you want, but it would
be somewhat Intel specific.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
