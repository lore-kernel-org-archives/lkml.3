Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3KZOdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:33:25 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:33037 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab3KZOdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:33:22 -0500
Date: Tue, 26 Nov 2013 11:33:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 21/25] perf evsel: Skip ignored symbols while printing
 callchain
Message-ID: <20131126143313.GD14838@ghostprotocols.net>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
 <1385389075-7989-22-git-send-email-acme@infradead.org>
 <52947D65.4050405@intel.com>
 <20131126142002.GC14838@ghostprotocols.net>
 <5294B06A.60104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5294B06A.60104@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 26, 2013 at 07:30:02AM -0700, David Ahern escreveu:
> On 11/26/13, 7:20 AM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Nov 26, 2013 at 12:52:21PM +0200, Adrian Hunter escreveu:
> >>On 25/11/13 16:17, Arnaldo Carvalho de Melo wrote:
> >>>From: David Ahern <dsahern@gmail.com>
> >>>  	} else {
> >>>+		if (al.sym->ignore)

> >>Seems to segfault here because sym is null

> >>>+			return;

> >Changed it to look at (al.sym && al.sym->ignore), the rest of the code
> >already checkfs if al.sym is NULL (printing [unknown], etc), can you
> >please take a look at:

> >https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=c0dd57452349779e0e5d436db8f9448dfffcc512

> >In an updated acme/perf/core branch?
 
> Looks good to me. That's what I was going to send you. Sorry for the noise.

No problem, I'll regenerate a +perf-core-for-mingo signed tag and send
it with this new version with a [PATCH N/M v2] together with a new set
of patches that I've put there today, not resending the unmodified
patches from last pull req.

Is that ok with you Ingo?

- Arnaldo
