Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3LRPvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:51:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab3LRPu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:50:59 -0500
Date: Wed, 18 Dec 2013 16:50:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/18] perf tools: Introduce struct add_entry_iter
Message-ID: <20131218155040.GI4146@krava.brq.redhat.com>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <1387344086-12744-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387344086-12744-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:21:12PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There're some duplicate code when adding hist entries.  They are
> different in that some have branch info or mem info but generally do
> same thing.  So introduce new struct add_entry_iter and add callbacks
> to customize each case in general way.
> 
> The new perf_evsel__add_entry() function will look like:
> 
>   iter->prepare_entry();
>   iter->add_single_entry();
> 
>   while (iter->next_entry())
>     iter->add_next_entry();
> 
>   iter->finish_entry();
> 
> This will help further work like the cumulative callchain patchset.

cool, I was waiting for this one! I have another user
for it, I'll test by rebasing my code ;-)

thanks,
jirka
