Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3GXNQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3GXNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:16:06 -0400
Date: Wed, 24 Jul 2013 15:15:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 13/15] perf tools: expand
 perf_event__synthesize_sample()
Message-ID: <20130724131526.GD4203@krava.brq.redhat.com>
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com>
 <1374144177-24762-14-git-send-email-adrian.hunter@intel.com>
 <20130724125025.GA4203@krava.brq.redhat.com>
 <51EFD368.2080901@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFD368.2080901@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:15:20PM +0300, Adrian Hunter wrote:

SNIP

> >> +	}
> >> +
> >> +	if (type & PERF_SAMPLE_REGS_USER) {
> >> +		if (sample->user_regs.regs && sample_regs_user) {
> >> +			*array++ = sample_regs_user;
> > 
> > it's 'enum perf_sample_regs_abi' value that goes here ^^^
> > 
> > I guess for now it could be hardcoded like:
> > 
> > #if defined(__x86_64__)
> > abi = PERF_SAMPLE_REGS_ABI_64
> > #else
> > #if defined(__i386__)
> > abi = PERF_SAMPLE_REGS_ABI_64

ugh, PERF_SAMPLE_REGS_ABI_32 ^^^ of course ;-)

> > #endif
> > WARN()
> > #endif
> 
> Thanks for reviewing this.
> 
> Why isn't it better to leave it as a parameter?

np, you could have it as parameter.. but I guess for now
you'll endup with above code in the upper layer anyway

jirka
