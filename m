Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3LRPJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:09:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3LRPJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:09:19 -0500
Date: Wed, 18 Dec 2013 16:09:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow
 tracing units
Message-ID: <20131218150900.GU21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
 <20131217161126.GL13532@twins.programming.kicks-ass.net>
 <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218133439.GR21999@twins.programming.kicks-ass.net>
 <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
 <20131218141125.GT21999@twins.programming.kicks-ass.net>
 <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:22:36PM +0200, Alexander Shishkin wrote:
> > Still confused, if you cannot copy it into one buffer, then why can you
> > copy it into a second buffer?
> 
> It's not copied, hardware writes directly into that second buffer.

Where's the PT documentation? I can't find it in the SDM and your ISA
extensions link is a generic Intel website which is friggin useless
(like all corporate websites strive to be).

Your actual PT patch doesn't describe how the things works either, and
while I could go read the code, I'm too lazy.

The thing is; why can't you zero-copy whatever buffer the hardware
writes into, into the normal buffer?

Machinery like that would also be useful to zero-copy bits out of the
buffer right into the page-cache.

> I've done the same with BTS now (as Ingo suggested) and it also benefits
> from this approach.

The problem with DS is that it needs physically contiguous pages is it
not? So you cannot really allocate a large buffer, and you end up
needing to copy or swizzle stuff.
