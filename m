Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3LPPpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:45:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:5606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab3LPPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:45:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,495,1384329600"; 
   d="scan'208";a="425419347"
Date: Mon, 16 Dec 2013 07:45:27 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131216154527.GX22695@tassilo.jf.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
 <20131211134724.GC3101@gmail.com>
 <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131216143751.GA7959@gmail.com>
 <20131216151852.GW22695@tassilo.jf.intel.com>
 <20131216153008.GA26686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216153008.GA26686@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're right it's extremely slow. But it can still be relevant for debugging,
> at least for apps that don't do too much CPU bound stuffs.

There are patches from Markus already for gdb to use it (using the old
BTS perf interface). I'm not sure they have been merged into gdb
mainline yet though.

> My hope has always been that we can make a userspace function graph tracer
> out of its dumps. And I think we can, I'm pretty sure that would be a useful tool.

I wrote one, based on the __fentry__, like the kernel:
http://github.com/andikleen/ftracer

BTS has no timing information, so you could at best do a function tracer
without timing.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
