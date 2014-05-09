Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbaEIR3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:29:06 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:45973 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaEIR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:29:04 -0400
Message-ID: <1399656540.2169.20.camel@j-VirtualBox>
Subject: Re: [PATCH 2/2] sched: Fix next_balance logic in
 rebalance_domains() and idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, jason.low2@hp.com
Date: Fri, 09 May 2014 10:29:00 -0700
In-Reply-To: <20140509090805.GK30445@twins.programming.kicks-ass.net>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
	 <1398725155-7591-3-git-send-email-jason.low2@hp.com>
	 <1399568364.2030.9.camel@j-VirtualBox> <20140508173835.GB9838@gmail.com>
	 <1399587244.2030.59.camel@j-VirtualBox>
	 <1399596562.2200.7.camel@j-VirtualBox>
	 <20140509090805.GK30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 11:08 +0200, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 05:49:22PM -0700, Jason Low wrote:
> > On Thu, 2014-05-08 at 15:14 -0700, Jason Low wrote:
> > > Hi Ingo, Peter,
> > > 
> > > Were there NULL domains on the test system? If so, I think we can
> > > address the problem by doing update_next_balance() only if the below
> > > rcu_dereference_check_sched_domain() returns a non-null domain.
> > 
> > Also, below is a patch which has the change:
> > 
> 
> Thanks, and yes, NULL domains are a perfectly normal thing to have
> (though not common on normal boot paths).

Okay. Likewise, on my test machine, I offline all but 1 CPU
in order to try reproducing the issue.

Thanks,
Jason

