Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3IBR1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:27:04 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43021 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3IBR1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:27:01 -0400
Date: Mon, 2 Sep 2013 19:26:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: eranian@gmail.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
Message-ID: <20130902172659.GJ19750@two.firstfloor.org>
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
 <CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
 <87ob8cdji8.fsf@tassilo.jf.intel.com>
 <CAMsRxfLf4mSVEMnDr1AqD-=qrhBoeVWK6H0Jhb5kcHK7=OajmQ@mail.gmail.com>
 <alpine.DEB.2.10.1309020914030.26568@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1309020914030.26568@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume he means MAP_POPULATE

Yes.

> 
> which does improve things, from ~3000 cycles to ~219 cycles but that's 
> still more overhead than the ~130 or so you get by manually touching the 
> page first.

That seems odd. It should be the same.

Can you do a trace-cmd function trace and compare the two cases?

trace-cmd record -p function_graph ...
trace-cmd report

(as usual for tracing perf remove the useless -pg removal for perf in
kernel/events/Makefile and arch/x86/kernel/cpu/Makefile first)

-Andi
