Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3KZQTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:19:00 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58816 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3KZQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:18:59 -0500
Date: Tue, 26 Nov 2013 17:18:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 21/25] perf evsel: Skip ignored symbols while printing
 callchain
Message-ID: <20131126161852.GC7775@gmail.com>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
 <1385389075-7989-22-git-send-email-acme@infradead.org>
 <52947D65.4050405@intel.com>
 <20131126142002.GC14838@ghostprotocols.net>
 <5294B06A.60104@gmail.com>
 <20131126143313.GD14838@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126143313.GD14838@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Nov 26, 2013 at 07:30:02AM -0700, David Ahern escreveu:
> > On 11/26/13, 7:20 AM, Arnaldo Carvalho de Melo wrote:
> > >Em Tue, Nov 26, 2013 at 12:52:21PM +0200, Adrian Hunter escreveu:
> > >>On 25/11/13 16:17, Arnaldo Carvalho de Melo wrote:
> > >>>From: David Ahern <dsahern@gmail.com>
> > >>>  	} else {
> > >>>+		if (al.sym->ignore)
> 
> > >>Seems to segfault here because sym is null
> 
> > >>>+			return;
> 
> > >Changed it to look at (al.sym && al.sym->ignore), the rest of the code
> > >already checkfs if al.sym is NULL (printing [unknown], etc), can you
> > >please take a look at:
> 
> > >https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=c0dd57452349779e0e5d436db8f9448dfffcc512
> 
> > >In an updated acme/perf/core branch?
>  
> > Looks good to me. That's what I was going to send you. Sorry for the noise.
> 
> No problem, I'll regenerate a +perf-core-for-mingo signed tag and 
> send it with this new version with a [PATCH N/M v2] together with a 
> new set of patches that I've put there today, not resending the 
> unmodified patches from last pull req.
> 
> Is that ok with you Ingo?

Sounds good to me!

Thanks,

	Ingo
