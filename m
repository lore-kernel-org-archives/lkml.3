Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaCRPLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:11:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:27809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaCRPLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,678,1389772800"; 
   d="scan'208";a="502337128"
Date: Tue, 18 Mar 2014 08:05:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH] tools, perf: Add asprintf replacement
Message-ID: <20140318150533.GA3132@tassilo.jf.intel.com>
References: <1394520204-22613-1-git-send-email-andi@firstfloor.org>
 <20140318142632.GB6482@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318142632.GB6482@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Humm, this unconditionally replaces it with an alternative that limits
> the buffer to a fixed size :-\

Better than corrupting memory.

I guess you could use two passes to avoid the limit, but it would surprise me
if anything in perf needs more than 1K of printf. One issue 
with doing two passes is that I wasn't sure the snprintf return
value would work properly on all libcs (e.g. the weirdo one Android uses)

> 
> Do you recall at least one of those old glibc version/release number?

glibc-2.13-2.x86_64 (FC14)

> 
> A reproducer? So that I can try to reproduce it here and try to polish
> this a bit more...

I saw it with perf report --branch-history in TUI mode and then pressing
e. But even running valgrind in stdio mode showed some corruption.
Without the patch also using some of the --call-graph options segfaulted.

-Andi
