Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaANNRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:17:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:17:51 -0500
Date: Tue, 14 Jan 2014 14:17:31 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/28] perf report: Cache cumulative callchains
Message-ID: <20140114131731.GC5520@krava.brq.redhat.com>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-11-git-send-email-namhyung@kernel.org>
 <20140109180627.GC11793@krava.brq.redhat.com>
 <871u0bbfnd.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u0bbfnd.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 08:55:50AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> Thanks for reminding me. :)
> 
> On Thu, 9 Jan 2014 19:06:28 +0100, Jiri Olsa wrote:
> > On Wed, Jan 08, 2014 at 05:46:15PM +0900, Namhyung Kim wrote:
> 
> [SNIP]
> >> +	/*
> >> +	 * Check if there's duplicate entries in the callchain.
> >> +	 * It's possible that it has cycles or recursive calls.
> >> +	 */
> >> +	for (i = 0; i < iter->curr; i++) {
> >> +		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
> >
> > we need here:
> > 			iter->he = he_cache[i];
> >
> >> +			return 0;
> >> +	}
> >
> > otherwise iter->he and al are not in sync and 
> > hist_entry__inc_addr_samples fails in hist_iter_cb
> 
> Right.  But the point of the he_cache is to skip duplicate entries.  So
> I'd like to change it like setting it to NULL and check it before the
> callback function:
> 
> 	while (iter->next_entry(iter, al)) {
> 		err = iter->add_next_entry(iter, al);
>                 if (err)
> 			break;
> 
> 		if (iter->he && iter->add_entry_cb) {
> 			err = iter->add_entry_cb(iter, al, ...);
> 			if (err)
> 				break;
> 		}
>         }
> 
> What do you think?

yep, better ;-) I saw you sent v6.. I'll check that

jirka
