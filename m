Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3CKHjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:39:15 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33538 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3CKHjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:39:13 -0400
Date: Mon, 11 Mar 2013 08:39:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>
Subject: Re: [ANNOUNCE] 3.9-rc1-nohz1
Message-ID: <20130311073908.GA9988@gmail.com>
References: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
 <20130309082650.GA9944@gmail.com>
 <CAFTL4hxt5y2hdh0_LNA-08+jNTYwkjeg=QHBfgNf_X_XCHie1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxt5y2hdh0_LNA-08+jNTYwkjeg=QHBfgNf_X_XCHie1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >  - Please outline how the current TODO entries affect upstream
> >    mergability. Does it reduce the 'full'-ness of this dynticks mode?
> >    Outright buggy behavior? Other trade-offs?
> 
> Mostly this is about upstream features that won't be working with the current 
> state of the art: enqueuing a posix cpu timer on a nohz CPU may result in it being 
> ignored by the target due to the lack of ticking until expiration, perf events may 
> not be round-robined, etc... I'll make sure to document all these items.

So it's "buggy behavior of existing features" it appears?

It would be really useful to add some sort of 'make it safe easily' mechanism:

 - if a posix timer is enqueued on a CPU, then the CPU should have a timer ticking

 - if perf events are active on a CPU, then it should have a timer ticking

this would make it mergable, as most of the time systems don't have any of these 
facilities active. Plus this dynticks-off mechanism would also allow us to cover any 
other (still unknown) facility that regresses. So it would be nice to have that 
option.

Later on we could gradually eliminate these limitations. It would also be apparent 
where they are, just from grepping the source.

If that's done, and if it tests fine for a few weeks then this could be v3.10 
material IMO.

Thanks,

	Ingo
