Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3KAHCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:02:24 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38925 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3KAHCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:02:23 -0400
Date: Fri, 1 Nov 2013 08:02:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf version not set when building out of tree
Message-ID: <20131101070219.GA21471@gmail.com>
References: <5272E86B.7090003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5272E86B.7090003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> When building out of tree:
> 
> make perf-tar-src-pkg

What's the canonical way to build a perf tarball? I didn't find any 
makefile target for that.

> tar -xf perf-<ver>.tar -C /tmp
> cd /tmp/perf<ver>
> make -C tools/perf
> 
> you get the warning message:
> make[1]: *** No rule to make target `kernelversion'.  Stop.
> 
> which comes from tools/perf/util/PERF-VERSION-GEN,
> 
> if test -z "$TAG"
> then
>     TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
> fi
> 
> There is no top level Makefile. perf is actually built, but has no
> version info:
> 
> $ tools/perf/perf --version
> perf version
> 
> I thought someone had proposed a way to fix that.

I think we should pack the PERF-VERSION-FILE with the tarball and 
use that. This needs roughly 3 changes:

 - make PERF-VERSION-FILE part of the tarball
 - make sure it's not zapped on 'make clean'
 - don't try to regenerate it if there's no git repository to get a version from

Thanks,

	Ingo
