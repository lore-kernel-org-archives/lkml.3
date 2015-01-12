Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbbALOCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:02:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:53360 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbALOCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:02:33 -0500
Date: Mon, 12 Jan 2015 11:02:28 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/4] perf tools: Allow use of an exclusive option more
 than once
Message-ID: <20150112140228.GG12406@kernel.org>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
 <54B3B397.8080808@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3B397.8080808@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 12, 2015 at 08:44:23PM +0900, Masami Hiramatsu escreveu:
> (2015/01/10 19:33), Namhyung Kim wrote:
> > The exclusive options are to prohibit use of conflicting options at the
> > same time.  But it had a side effect that it also limits a such option
> > can be used at most once.  Currently the only user of the flag is perf
> > probe and it allows to use such options more than once, but when one
> > tries to use it, perf will fail like below:
> > 
> >   $ sudo perf probe -x /lib/libc-2.20.so --add malloc --add free
> >     Error: option `add' cannot be used with add
> >   ...
> > 
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks, applied to perf/urgent
 
> Thanks!
> 
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/parse-options.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
> > index f62dee7bd924..4a015f77e2b5 100644
> > --- a/tools/perf/util/parse-options.c
> > +++ b/tools/perf/util/parse-options.c
> > @@ -46,7 +46,7 @@ static int get_value(struct parse_opt_ctx_t *p,
> >  		return opterror(opt, "is not usable", flags);
> >  
> >  	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
> > -		if (p->excl_opt) {
> > +		if (p->excl_opt && p->excl_opt != opt) {
> >  			char msg[128];
> >  
> >  			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
