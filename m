Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3EJLwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:52:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:57651 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab3EJLwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:52:20 -0400
Message-ID: <1368186695.4524.27.camel@pasglop>
Subject: Re: Invalid perf_branch_entry.to entries question
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
        eranian@google.com, Anshuman Khandual <anshuman.khandual@in.ibm.com>
Date: Fri, 10 May 2013 21:51:35 +1000
In-Reply-To: <CAEjGV6x1=6iFUwQs6=5GY75-J9ZZzs8=CKE=+MGxdwoKycs9jA@mail.gmail.com>
References: <25394.1367890528@ale.ozlabs.ibm.com>
	 <20130508155929.GA8459@dyad.programming.kicks-ass.net>
	 <14691.1368052755@ale.ozlabs.ibm.com>
	 <20130510104352.GF31235@dyad.programming.kicks-ass.net>
	 <CAEjGV6x1=6iFUwQs6=5GY75-J9ZZzs8=CKE=+MGxdwoKycs9jA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 20:50 +1000, Michael Neuling wrote:
> The buffer is in the core (not main memory) and hence only has limited
> entries.  So skipping entries that can hopefully be determined in
> other ways means we can log more branches.
> 
> That being said, it's a PITA for the kernel ;-)

I would suggest flagging them. As you mention, the code might have been
modified since the sample was taken. Even if it still looks like a
branch and you can compute the "To" address it might not be the right
one ... at least userspace should be notified that this specific sample
is to handle with care.

And if you just can't read the instruction or it's not a branch anymore,
then stick a -1 in there, no way it can be a valid branch address :-)

Cheers,
Ben.


