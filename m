Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3KFNm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:42:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56312 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3KFNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:42:24 -0500
Date: Wed, 6 Nov 2013 10:42:10 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/10] perf hists: Consolidate __hists__add_*entry()
Message-ID: <20131106134210.GA2711@ghostprotocols.net>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
 <1383682201-19399-2-git-send-email-acme@infradead.org>
 <20131105215243.GA8303@sdfg.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105215243.GA8303@sdfg.com.ar>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 05, 2013 at 09:52:43PM +0000, Rodrigo Campos escreveu:
> On Tue, Nov 05, 2013 at 05:09:52PM -0300, Arnaldo Carvalho de Melo wrote:
> > @@ -486,15 +425,15 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
> >  		.stat = {
> > -			.period	= period,
> >  			.nr_events = 1,
> > +			.period	= period,
> >  			.weight = weight,
> >  		},

> Isn't this seems unrelated and unneeded ?

> The "period" field is before the "nr_events" field in the struct, so maybe is
> more clear to leave it as it was ?  The actual relative order (it has some more
> fields) in the struct is: period, weigth, nr_events. Might be better if they
> match that order here ? Although not sure since we are using the fields with
> name and is clear enough.

Yeah, this shouldn't be there, I thought about fixing this up to reduce
the patch size, but ended up being lenient.

Namhyung, please avoid such unneeded patch churn :-)

- Arnaldo
