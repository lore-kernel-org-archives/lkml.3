Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342Ab3GaOYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:24:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52122 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760136Ab3GaOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:24:17 -0400
Date: Wed, 31 Jul 2013 16:24:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130731142405.GB3008@twins.programming.kicks-ass.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
 <20130731141732.GD3614@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731141732.GD3614@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:17:32AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
> > Using the information in mmap events, perf tools can read object
> > code associated with sampled addresses.  A test is added that
> > compares bytes read by perf with the same bytes read using
> > objdump.
> 
> So this parses objdump output, and we also already have the annotation
> logic that does that too, have you thought about having common routines
> for these two cases?
> 

Or better yet, stop using objdump like this and start using libbfd
directly. The only reason we did horrible things like parsing objdump
output is because nobody knew how the underlying stuff actually worked
and we wanted to have something quick.


