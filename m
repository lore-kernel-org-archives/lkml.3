Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3JJTuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:50:24 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45023 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3JJTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:50:22 -0400
Date: Thu, 10 Oct 2013 16:50:14 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131010195014.GJ28369@ghostprotocols.net>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
 <20131009145157.GA27139@gmail.com>
 <20131010192608.GI28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010192608.GI28369@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 10, 2013 at 04:26:08PM -0300, Arnaldo Carvalho de Melo escreveu:
> Two problems:
> 
> the message:
> 
>   BUILD:   Doing 'make -j1' parallel build
> 
> Looks funny: 'parallel' && -j1? :-)
> 
> This is on fedora12, on a kvm guest, nfs mounting /home/acme/git, all works
> well up to the liblk.a part, cloning it to do it without NFS to continue
> testing the integration of acme/perf/core with the build speedup patches.

<SNIP>

>   AR       liblk.a
> rm: cannot remove `liblk.a': Permission denied
> make[2]: *** [liblk.a] Error 1
> make[1]: *** [/tmp/build/perf/liblk.a] Error 2
> make: *** [install] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> [acme@fedora12 linux]$ fg
> -bash: fg: current: no such job
> [acme@fedora12 linux]$ vim tools/perf/Makefile.perf 

/me scratches head, tried this on another kvm guest, ubuntu 13.04,
x86_64, works as expected, but stumbled in another problem:

acme@ubuntu-acme:~/git/linux$ time make -C tools/perf -f tests/make
make: Entering directory `/home/acme/git/linux/tools/perf'
make[3]: *** No rule to make target
`/home/git/linux/tools/lib/traceevent/trace-seq.c', needed by
`.trace-seq.d'.  Stop.
make[2]: ***
[/home/acme/git/linux/tools/lib/traceevent/libtraceevent.a-clean] Error
2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [clean] Error 2
make: *** [make_pure] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m0.254s
user	0m0.064s
sys	0m0.084s
acme@ubuntu-acme:~/git/linux$

And this does work on a RHEL6 box, continue to investigate...

- Arnaldo
