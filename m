Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaKJPaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:30:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbaKJPaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:30:09 -0500
Date: Mon, 10 Nov 2014 16:29:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 14/18] perf tools: Make vmlinux short name more like
 kallsyms short name
Message-ID: <20141110152934.GA8123@krava.redhat.com>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
 <1415307879-912-15-git-send-email-acme@kernel.org>
 <20141109075126.GB3366@krava.redhat.com>
 <87r3xbvazp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3xbvazp.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:13:46PM +0900, Namhyung Kim wrote:

SNIP

> >> +			dso__set_short_name(dso, "[kernel.vmlinux]", false);
> >> +
> >
> > heya,
> > I've got attached segfault in perf script because of this,
> > if I revert it's ok..
> 
> Oops, sorry.  It seems somehow to fail to find a matching kernel dso
> from the build-id table..  anyway we need to access 'kernel' instead of
> 'dso' since it might be invalid at this time.
> 
> Could you please check below patch?
> 
> 
> From e28ec815465721b81669c47eb00d8307f4b424cd Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Mon, 10 Nov 2014 15:05:26 +0900
> Subject: [PATCH] perf tools: Fix segfault due to invalid kernel dso access
> 
> When processing kernel mmap event, it should access the 'kernel'
> variable as sometimes it cannot find a matching dso from build-id
> table so 'dso' might be invalid.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

yep, works nicely now

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
