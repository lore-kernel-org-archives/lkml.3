Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaK0ToP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:44:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:27049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaK0ToO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,471,1413270000"; 
   d="scan'208";a="615151215"
Date: Thu, 27 Nov 2014 11:44:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Do not fail on processing out of order event
Message-ID: <20141127194413.GN10824@tassilo.jf.intel.com>
References: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417016371-30249-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 04:39:31PM +0100, Jiri Olsa wrote:
> Linus reported perf report command being interrupted due to
> processing of 'out of order' event, with following error:
> 
>   Timestamp below last timeslice flush
>   0x5733a8 [0x28]: failed to process type: 3
> 
> I could reproduce the issue and in my case it was caused by one
> CPU (mmap) being behind during record and userspace mmap reader
> seeing the data after other CPUs data were already stored.

I like the change. This problem hit me a couple of times too.

-Andi
