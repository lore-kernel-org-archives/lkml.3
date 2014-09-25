Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaIYExT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:53:19 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:59500 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaIYExR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:53:17 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 25 Sep 2014 00:59:31 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cong Wang <cwang@twopensource.com>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com> <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I noticed Cong Wang's patch (3577af70a2ce4853d58e57d832e687d739281479)
	perf: Fix a race condition in perf_remove_from_context()

and that sounds a lot like the weird fork()/memory-corruption bug that the 
fuzzer has been triggering.

So I applied that patch alone on top of the 3.17-rc4 kernel that I could 
reproducibly reboot... and with the patch I can't trigger the problem 
anymore.

Now that just might mean the patch pushed the code around enough so my 
test doesn't trigger, but there is hope that maybe this fixes things.

Cong Wang, do you have more info on how you came across this bug?  And how 
you tracked down the problem?

Thanks,

Vince
