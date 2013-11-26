Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3KZOUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:20:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3KZOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:20:18 -0500
Date: Tue, 26 Nov 2013 11:20:02 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 21/25] perf evsel: Skip ignored symbols while printing
 callchain
Message-ID: <20131126142002.GC14838@ghostprotocols.net>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
 <1385389075-7989-22-git-send-email-acme@infradead.org>
 <52947D65.4050405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52947D65.4050405@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 26, 2013 at 12:52:21PM +0200, Adrian Hunter escreveu:
> On 25/11/13 16:17, Arnaldo Carvalho de Melo wrote:
> > From: David Ahern <dsahern@gmail.com>
> >  	} else {
> > +		if (al.sym->ignore)
> 
> Seems to segfault here because sym is null
> 
> > +			return;
> > +

Changed it to look at (al.sym && al.sym->ignore), the rest of the code
already checkfs if al.sym is NULL (printing [unknown], etc), can you
please take a look at:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=c0dd57452349779e0e5d436db8f9448dfffcc512

In an updated acme/perf/core branch?

- Arnaldo
