Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaCYVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:01:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:40489 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaCYVBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="499415166"
Date: Tue, 25 Mar 2014 14:01:09 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] tools, perf: Allow the user to disable time stamps
Message-ID: <20140325210109.GH15074@tassilo.jf.intel.com>
References: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
 <CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Timestamp are useful to order samples during reporting.
> How do you do with it if you monitor multi-threaded (multi-cpu)
> workloads. This is only good for single thread or single CPU
> measurements. Or am I missing something?

For a perf report order doesn't matter (except against mmaps)
The CPUs are still separated of course

You're right for some special analysis it matters, that is why
it is only an option. 

But for the standard "only care about perf report and 
don't care about about program startup" case it's a nice saving.

-Andi
