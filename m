Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaKUSq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:46:56 -0500
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:35203 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKUSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:46:55 -0500
X-Greylist: delayed 85246 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2014 13:46:55 EST
Message-ID: <1416595611.3482.3.camel@u64>
Subject: Re: [PATCH v2] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, dbueso@suse.de, a.p.zijlstra@chello.nl,
        paulus@samba.org, artagnon@gmail.com, jolsa@redhat.com,
        dvhart@linux.intel.com, Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org
Date: Fri, 21 Nov 2014 10:46:51 -0800
In-Reply-To: <20141121155706.GB18625@kernel.org>
References: <20141121155706.GB18625@kernel.org>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 12:57 -0300, Arnaldo Carvalho de Melo wrote:
> > 
> > Test machine is a 8-sockets 80 cores Westmere system HT-off on v3.17-rc6.
> > 
> > 	AIM7		AIM7		perf-bench	perf-bench
> > Users	Jobs/min	Jobs/min/child	Ops/sec		Ops/sec/child
> > 500	119668.25	239.34		104249		208
> > 600	126074.90	210.12		106136		176
> > 700	128662.42	183.80		106175		151
> > 800	119822.05	149.78		106290		132
> > 900	106150.25	117.94		105230		116
> > 1000	104681.29	104.68		106489		106
> > 
> > Perf trace for AIM7 fserver:
> 
> I will rename this from "Perf trace for AIM7 fserver" to "Perf report
> for AIM7 fserver", as there is a 'perf trace' tool and that produces
> different output, etc.
> 

I will make this changes for the next revision.

> > 14.51%	reaim  		[kernel.kallsyms]	[k] osq_lock
> > 4.98%	reaim  		reaim			[.] add_long
> > 4.98%	reaim  		reaim			[.] add_int
> > 4.31%	reaim  		[kernel.kallsyms]	[k] mutex_spin_on_owner
> > ...
> > 
> > Perf trace of perf bench creat
> 
> Ditto and here will replace 'perf bench creat' with the new naming:
> "perf bench locking vfs", right?
> 

Yes perf bench creat is suppose to be perf bench vfs.  I will make the
correction for the next revision.



