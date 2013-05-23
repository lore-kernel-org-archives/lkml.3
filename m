Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3EWOJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:09:15 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:55443 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757869Ab3EWOJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:09:12 -0400
Date: Thu, 23 May 2013 14:09:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130523104154.GA23650@twins.programming.kicks-ass.net>
Message-ID: <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523104154.GA23650@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.23-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Peter Zijlstra wrote:

> Right it doesn't. I think the easiest solution for now is to not copy the VMA
> on fork().

Right. Pinned pages are not inherited. If a page is unpinned then that is
going to happen for all address spaces that reference the page.

> But I totally missed patch bc3e53f682d that introduced pinned_vm, AFAICT that
> also wrecked some accounting. We should still account both against
> RLIMIT_MEMLOCK.

The point of the patch was to unwreck accounting. Before the patch mlocked
pages were counted twice which resulted in stramge VM scenarios where more
pages were mlocked than memory available. Note that a pinned page may also
be mlocked.

Simply adding the two will reintroduce the problems that were fixed by the
patch.
