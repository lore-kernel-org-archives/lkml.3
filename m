Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaJHWLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:11:23 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:54437 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJHWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:11:17 -0400
Message-ID: <1412806271.2908.3.camel@u64>
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        dbueso@suse.de, a.p.zijlstra@chello.nl, paulus@samba.org,
        artagnon@gmail.com, jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Date: Wed, 08 Oct 2014 15:11:11 -0700
In-Reply-To: <20141001171226.GF2799@kernel.org>
References: <1412120999.2941.11.camel@u64>
	 <20141001052832.GA32248@gmail.com> <20141001171226.GF2799@kernel.org>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 14:12 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 01, 2014 at 07:28:32AM +0200, Ingo Molnar escreveu:
> > If you compare an strace of AIM7 steady state and 'perf bench 
> > lock' steady state, is it comparable, i.e. do the syscalls and 
> 
> Isn't "lock" too generic? Isn't this stressing some specific lock and if
> so shouldn't that be made abundantly clear in the 'perf bench' test name
> and in the docs?
> 

In this micro benchmark, I am trying to exhibit the same locking
contention shown in an AIM7 fserver workload.  Since the creat(2) system
call is file system dependent running this on different file system show
different lock being contended that is why i did not specify specific
lock name in the doc.  Do you have a suggestion here on how i should
name this benchmark?

> Or is this the case that it started by using 'creat' calls to stress
> some locking and will go on adding more syscalls to stress more kernel
> locks?
> 

When running all AIM7 workloads looking for locking contention to
reproduce, creat was the only one I found interesting and useful to
stress locking contention.




