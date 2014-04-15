Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaDOL4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:56:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaDOL4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:56:44 -0400
Date: Tue, 15 Apr 2014 13:56:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Richard Yao <ryao@gentoo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
Message-ID: <20140415115629.GF1700@krava.brq.redhat.com>
References: <1397148779-9169-1-git-send-email-ryao@gentoo.org>
 <871twztacr.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871twztacr.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:44:52PM +0900, Namhyung Kim wrote:
> Hi Richard,
> 
> On Thu, 10 Apr 2014 12:52:59 -0400, Richard Yao wrote:
> > Modules installed outside of the kernel's build system should go into
> > "%s/lib/modules/%s/extra", but at present, perf will only look at them
> > when they are in "%s/lib/modules/%s/kernel". Lets encourage good
> > citizenship by relaxing this requirement to "%s/lib/modules/%s". This
> > way open source modules that are out-of-tree have no incentive to start
> > populating a directory reserved for in-kernle modules and I can stop hex
> > editing my system's perf binary when profiling OSS out-of-tree modules.
> 
> But it'll make the perf traverses all the source and build directories
> too, right?  I don't think it's a right thing to do.
> 
> Maybe we can also change stat() in map_groups__set_modules_path_dir() to
> lstat() so that it cannot go to unwanted directories in that case.  Or
> else, just checking "kernel" and "extra" directories will work.

yay, forgot about source directory.. :-\  looks like lstat should
help, but hardcoding kernel and extra sounds better to me.

Richard, please send updated patch

thanks,
jirka
