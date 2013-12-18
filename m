Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3LRRfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:35:39 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:61315 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3LRRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:35:36 -0500
Date: Wed, 18 Dec 2013 14:35:28 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf sort: Compare addresses if no symbol info
Message-ID: <20131218173528.GA4819@ghostprotocols.net>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <1387344086-12744-2-git-send-email-namhyung@kernel.org>
 <20131218153849.GF4146@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218153849.GF4146@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 18, 2013 at 04:38:49PM +0100, Jiri Olsa escreveu:
> On Wed, Dec 18, 2013 at 02:21:09PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > If a hist entry doesn't have symbol information, compare it with its
> > address.  Currently it only compares its level or whether it's NULL.
> > This can lead to an undesired result like an overhead exceeds 100%
> > especially when callchain accumulation is enabled by later patch.
> > 
> > Cc: Stephane Eranian <eranian@google.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/sort.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> > index 8b0bb1f4494a..68a4fd2f505e 100644
> > --- a/tools/perf/util/sort.c
> > +++ b/tools/perf/util/sort.c
> > @@ -161,6 +161,11 @@ struct sort_entry sort_dso = {
> >  
> >  /* --sort symbol */
> >  
> > +static int64_t _sort__addr_cmp(u64 left_ip, u64 right_ip)
> > +{
> > +	return (int64_t)(right_ip - left_ip);
> > +}
> > +
> 
> what's the reason for the leading '_' in the name?

Yeah, I'm curious as well, the convention is to only use double _ in
front of functions when it does a little less than a function of the
same name without such prefix, like locking, etc.

- Arnaldo
 
> otherwise:
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> jirka
