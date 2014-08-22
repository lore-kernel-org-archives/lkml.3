Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaHVICp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:02:45 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:52594 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaHVICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:02:41 -0400
Date: Fri, 22 Aug 2014 10:02:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/2] perf hists browser: Consolidate callchain print
 functions in TUI
Message-ID: <20140822080236.GB7714@gmail.com>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
 <1408583746-5540-3-git-send-email-namhyung@kernel.org>
 <20140821154353.GL2892@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821154353.GL2892@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Em Thu, Aug 21, 2014 at 10:15:46AM +0900, Namhyung Kim escreveu:
> > Currently there're two callchain print functions in TUI - one for the
> > hists browser and another for file dump.  They do almost same job so
> > it'd be better consolidate the codes.
> 
> Some comments below, thanks for doing this work!
>  
> > To do that, move row calculation code into a print callback so that
> > the dump code cannot be limited by the current screen size.
>  
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/ui/browsers/hists.c | 210 +++++++++++++++--------------------------
> >  1 file changed, 76 insertions(+), 134 deletions(-)
> > 
> > diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> > index 519353d9f5fb..48d8c8eee6c2 100644
> > --- a/tools/perf/ui/browsers/hists.c
> > +++ b/tools/perf/ui/browsers/hists.c
> > @@ -477,20 +477,32 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
> >  	return bf;
> >  }
> >  
> > +struct callchain_print_arg {
> > +	/* for hists browser */
> > +	unsigned short row;
> > +	off_t row_offset;
> > +	bool is_current_entry;
> > +
> > +	/* for file dump */
> > +	FILE *fp;
> > +	int printed;
> > +};

Just a data type definition nitpicking pet peeve of mine, don't 
you guys too find this vertically aligned form infinitely more 
readable:

struct callchain_print_arg {
	/* for hists browser */
	unsigned short	row;
	off_t		row_offset;
	bool		is_current_entry;

	/* for file dump */
	FILE		*fp;
	int		printed;
};

especially when looking at it via email, without syntax 
highlighting?

Thanks,

	Ingo
