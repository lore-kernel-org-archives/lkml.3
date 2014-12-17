Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaLQW25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:28:57 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:47268 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaLQW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:28:56 -0500
Message-ID: <1418855330.3962.5.camel@u64>
Subject: Re: [PATCH  v3] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, artagnon@gmail.com, jolsa@redhat.com,
        dvhart@linux.intel.com, Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org
Date: Wed, 17 Dec 2014 14:28:50 -0800
In-Reply-To: <20141211211254.GC9845@kernel.org>
References: <1418165693.6540.5.camel@u64> <20141211211254.GC9845@kernel.org>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 18:12 -0300, Arnaldo Carvalho de Melo wrote:
> > +struct timeval start, end, total;
> > +static unsigned int start_nr = 100;
> > +static unsigned int end_nr = 1100;
> > +static unsigned int increment_by = 100;
> > +static int bench_dur = NOTSET;
> > +static int num_jobs = NOTSET;
> > +static bool run_jobs;
> > +static int n_pro;
> > +
> > +/* Shared variables between fork processes*/
> > +unsigned int *finished, *setup;
> > +unsigned long long *shared_workers;
> > +char *tmp_dir;
> 
> Are you sure these variables aren't static?
> 

Yes you are right.  I will change these to static.


> > +/* Running bench vfs workload */
> > +static void *run_bench_vfs(struct worker *workers)
> > +{
> > +	int fd;
> > +	unsigned long long nr_ops = 0;
> > +	int jobs = num_jobs;
> > +
> > +	sprintf(workers->str, "%s/%d-XXXXXX", tmp_dir, getpid());
> 
> 
> Please use snprintf, checking for overflows on the target string
> 

Thank you for pointing this out.  I will change all sprintf to use
snprintf and check for overflows on the target string.


> > +
> > +	/* finished shared var is use to signal start and end of benchmark */
> > +	finished_tmp = (void *)mmap(0, sizeof(unsigned int), PROT_READ|PROT_WRITE,
> > +			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> 
> Why do you use these void * casts before mmap alreayd returns void *?
> 

Yes the cast to void here is redundant. I will remove the cast to (void
*) here.

> > +	if (finished_tmp == (void *) -1)
> 
> Please use MAP_FAILED instead of its equivalent (void *) -1.
> 

I will check for MAP_FAILED here instead.  Thank you for the suggestion.


-Tuan


