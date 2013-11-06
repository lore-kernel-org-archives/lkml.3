Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3KFI2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:28:50 -0500
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:42402 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3KFI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:28:49 -0500
Date: Wed, 6 Nov 2013 08:28:29 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/10] perf hists: Consolidate __hists__add_*entry()
Message-ID: <20131106082829.GA31007@sdfg.com.ar>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
 <1383682201-19399-2-git-send-email-acme@infradead.org>
 <20131105215243.GA8303@sdfg.com.ar>
 <87habqx7wb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87habqx7wb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 05:16:04PM +0900, Namhyung Kim wrote:
> Hi Rodrigo,
> 
> On Tue, 5 Nov 2013 21:52:43 +0000, Rodrigo Campos wrote:
> > On Tue, Nov 05, 2013 at 05:09:52PM -0300, Arnaldo Carvalho de Melo wrote:
> >> @@ -486,15 +425,15 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
> >>  		.ip	= al->addr,
> >>  		.level	= al->level,
> >>  		.stat = {
> >> -			.period	= period,
> >>  			.nr_events = 1,
> >> +			.period	= period,
> >>  			.weight = weight,
> >>  		},
> >
> > Isn't this seems unrelated and unneeded ?
> >
> > The "period" field is before the "nr_events" field in the struct, so maybe is
> > more clear to leave it as it was ?  The actual relative order (it has some more
> > fields) in the struct is: period, weigth, nr_events. Might be better if they
> > match that order here ? Although not sure since we are using the fields with
> > name and is clear enough.
> 
> Yes, it just a small unrelated cosmetic change.  I don't think the order
> matters much - it just makes my eyes a bit more comfortable. :)
> 
> IOW, I changed it since _add_branch_entry() and _add_mem_entry() do it
> slightly different order.  So I decided to clean it up and putting
> nr_events at first looked reasonable to me.

Great, sounds reasonable to me too :)




Thangs again,
Rodrigo
