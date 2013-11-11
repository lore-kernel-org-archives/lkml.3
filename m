Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3KKMoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:44:30 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42854 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KKMoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:44:22 -0500
Date: Mon, 11 Nov 2013 13:44:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131111124419.GA6740@gmail.com>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109141039.GM16117@laptop.programming.kicks-ass.net>
 <20131109142056.GA26079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109142056.GA26079@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > That said, I'm not sure what kernel you're running, but there were 
> > some issues with time-keeping hereabouts, but more importantly that 
> > second timing includes the printk() call of the first -- so that's 
> > always going to be fucked.
> 
> It's a recent tip:master. So the delta debug printout is certainly 
> buggy, meanwhile these lockup only happen with Vince selftests, and they 
> trigger a lot of these NMI-too-long issues, or may be that's the other 
> way round :)...
> 
> I'm trying to narrow down the issue, lets hope the lockup is not 
> actually due to printk itself.

I'd _very_ strongly suggest to not include the printk() overhead in the 
execution time delta! What that function wants to report is pure NMI 
execution overhead, not problem reporting overhead.

That way any large number reported there is always a bug somewhere, 
somehow.

Thanks,

	Ingo
