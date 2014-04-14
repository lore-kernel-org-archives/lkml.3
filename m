Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaDNLVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:21:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaDNLVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:21:19 -0400
Date: Mon, 14 Apr 2014 13:18:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] tools: Consolidate types.h
Message-ID: <20140414111805.GA7696@krava.brq.redhat.com>
References: <1393153753-2369-1-git-send-email-bp@alien8.de>
 <87eh2s55tg.fsf@rustcorp.com.au>
 <20140225070020.GA19504@pd.tnic>
 <87eh2r4c2d.fsf@rustcorp.com.au>
 <20140225140511.GD5982@ghostprotocols.net>
 <20140410173805.GA28613@pd.tnic>
 <20140411115930.GC1107@krava.brq.redhat.com>
 <20140412101455.GA30694@pd.tnic>
 <20140413112743.GB25088@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413112743.GB25088@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 01:27:43PM +0200, Borislav Petkov wrote:
> And while we're at it, let's do another consolidation:
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Sat, 12 Apr 2014 20:10:49 +0200
> Subject: [PATCH] tools: Consolidate types.h
> 
> Combine all definitions into a common tools/include/linux/types.h and
> kill the wild growth elsewhere. While at it, move u64_swap to its only
> user, evsel.h.

please put the 'u64_swap move' into separated patch
plus one nit below 

thanks,
jirka

> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  .../lockdep/uinclude => include}/linux/types.h     | 29 +++++++++++++++++-----
>  tools/perf/MANIFEST                                |  1 +

SNIP

> diff --git a/tools/perf/tests/perf-targz-src-pkg b/tools/perf/tests/perf-targz-src-pkg
> index 238aa3927c71..3017d82a700f 100755
> --- a/tools/perf/tests/perf-targz-src-pkg
> +++ b/tools/perf/tests/perf-targz-src-pkg
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  # Test one of the main kernel Makefile targets to generate a perf sources tarball
>  # suitable for build outside the full kernel sources.
>  #
> @@ -7,15 +7,17 @@
>  # like when we made some files that were in tools/perf/ available to other tools/
>  # codebases by moving it to tools/include/, etc.
>  
> +set -x
> +
>  PERF=$1
>  cd ${PERF}/../..
>  make perf-targz-src-pkg > /dev/null
>  TARBALL=$(ls -rt perf-*.tar.gz)
>  TMP_DEST=$(mktemp -d)
>  tar xf ${TARBALL} -C $TMP_DEST
> -rm -f ${TARBALL}
> +# rm -f ${TARBALL}
>  cd - > /dev/null
> -make -C $TMP_DEST/perf*/tools/perf > /dev/null 2>&1
> +make -C $TMP_DEST/perf*/tools/perf > w.log 2>&1
>  RC=$?
> -rm -rf ${TMP_DEST}
> +# rm -rf ${TMP_DEST}
>  exit $RC

leftover from another change ;-)

