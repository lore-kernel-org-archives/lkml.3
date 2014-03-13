Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaCMSSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:18:12 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35900 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaCMSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:18:07 -0400
Date: Thu, 13 Mar 2014 15:18:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf bench: Fix NULL pointer dereference in "perf bench
 all"
Message-ID: <20140313181801.GB2396@ghostprotocols.net>
References: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
 <20140313143456.GA2396@ghostprotocols.net>
 <CA+C-WL_2DrXFL6eMoyt2miwA53rZN=M0bNrirsra3oup-JdosA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+C-WL_2DrXFL6eMoyt2miwA53rZN=M0bNrirsra3oup-JdosA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 13, 2014 at 10:47:58AM -0400, Patrick Palka escreveu:
> On Thu, Mar 13, 2014 at 10:34 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Wed, Mar 12, 2014 at 06:40:51PM -0400, Patrick Palka escreveu:
> >> for_each_bench() must check that the "benchmarks" field of a collection
> >> is not NULL before dereferencing it because the "all" collection in
> >> particular has a NULL "benchmarks" field (signifying that it has no
> >> benchmarks to iterate over).

> >> This fixes a NULL pointer dereference when running "perf bench all".

> > Can you please mention against which tree you're fixing things? I just
> > tried to reproduce it here on perf/urgent and this problem is not
> > reproducible by simply running:

> >   perf bench all

> > So now I'm going to try on perf/core, tip/master, etc :-\
 
> I'm fixing this on top on Linus' tree, which is currently on ac9dc67b7.
 
> Without the patch, the output of "./perf bench all" looks like:

That helps, I didn't manage to reproduce it here, I think, because I
have the numa libs installed and then a numa bench is included, and it
seems broken, which stops 'perf bench all' before it hits this problem.

I'm fixing that problem and then will process your patch.

Please add the output, possibly trimmed if long, in your next changelog
messages, that helps in more quickly seeing what is happening and
comparing with results obtained elsewhere.

Thanks,

- Arnaldo
 
> # Running sched/messaging benchmark...
> # 20 sender and receiver processes per group
> # 10 groups == 400 processes run
> 
>      Total time: 0.623 [sec]
> 
> # Running sched/pipe benchmark...
> # Executed 1000000 pipe operations between two processes
> 
>      Total time: 32.199 [sec]
> 
>       32.199419 usecs/op
>           31056 ops/sec
> 
> # Running mem/memcpy benchmark...
> # Copying 1MB Bytes ...
> 
>        1.247206 GB/Sec
>        1.268263 GB/Sec (with prefault)
> 
> # Running mem/memset benchmark...
> # Copying 1MB Bytes ...
> 
>        1.429813 GB/Sec
>        8.418642 GB/Sec (with prefault)
> 
> zsh: segmentation fault  ./perf bench all
> 
> 
> Patrick
