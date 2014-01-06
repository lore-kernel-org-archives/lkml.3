Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaAFOdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:33:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaAFOdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:33:08 -0500
Date: Mon, 6 Jan 2014 15:32:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct add_entry_iter
Message-ID: <20140106143247.GD1183@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-2-git-send-email-namhyung@kernel.org>
 <20140105155510.GA9441@krava.brq.redhat.com>
 <87ob3pedv9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob3pedv9.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 05:03:22PM +0900, Namhyung Kim wrote:
> On Sun, 5 Jan 2014 16:55:10 +0100, Jiri Olsa wrote:
> > On Tue, Dec 24, 2013 at 05:22:07PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >
> > SNIP
> >
> >> +
> >> +out:
> >> +	iter->curr++;
> >> +	return err;
> >> +}
> >> +
> >> +static int
> >> +iter_finish_branch_entry(struct add_entry_iter *iter,
> >> +			 struct addr_location *al __maybe_unused)
> >> +{
> >> +	free(iter->priv);
> >> +	iter->priv = NULL;
> >
> > so branch_info is duplicated in the hist_entry__new.. it's not
> > easy to find why this one gets freed while mem_info stays ;-)
> 
> The branch_info is an array and each entry gets its own part in the
> array - so entries alloc & copy the (part of) branch info as the branch
> info iterated.  But mem info is a single data for a single entry so a
> new entry steals ownership of the mem info when created and not freed.
> 
> Maybe we can alloc & copy another mem info when adds an entry and free
> the original at iter->finish_entry(), but I felt it's unnecessary..
> 
> >
> > some comment about that here would help
> 
> How about this?
> 
>   /*
>    * The mem_info was either already freed in add_hist_entry() or
>    * passed to a new hist entry by hist_entry__new().
>    */
> 

sounds good, thanks
jirka
