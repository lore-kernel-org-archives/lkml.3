Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858Ab3JPIsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582Ab3JPIsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:48:00 -0400
Date: Wed, 16 Oct 2013 10:47:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/3] perf tools: Add data object to handle perf data file
Message-ID: <20131016084722.GA1042@krava.redhat.com>
References: <1381847254-28809-1-git-send-email-jolsa@redhat.com>
 <1381847254-28809-2-git-send-email-jolsa@redhat.com>
 <87a9ia9biw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9ia9biw.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:48:07AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Tue, 15 Oct 2013 16:27:32 +0200, Jiri Olsa wrote:
> > This patch is adding 'struct perf_data_file' object as
> > a placeholder for all attributes regarding perf.data
> > file handling. Changing perf_session__new to take it
> > as an argument.
> >
> > The rest of the functionality will be added later to keep
> > this change simple enough, because all the places using
> > perf_session are changed now.
> 
> All three look good.

thanks for review

> 
> Btw, are you planning to support multiple per-cpu file record?  As you
> know I suggested perf.data.dir approach in my perf-ftrace patchset (I'll
> resend a new version soonish) something like below.  What do you think?
> 
>   perf.data.dir/
>     |-- perf-cpu0.data
>     |-- perf-cpu1.data
>     |-- perf-cpu2.data
>     `-- perf-cpu3.data

yep, my initial attempt is to store cpu related data
into separated files and do some post merge or provide
merge tool for that.

it's probably good idea to place them into
separate directory

> 
> Maybe we could split sample data and other data (e.g. COMM, MMAP or some
> user data?) to another file(s).

you'd need to parse data stream for that

hum, or we could open that dummy event for auxiliary
events, and store them separately

thanks,
jirka
