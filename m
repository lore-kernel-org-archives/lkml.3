Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3FYHoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:44:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41129 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3FYHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:44:14 -0400
Date: Tue, 25 Jun 2013 09:44:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625074401.GY28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
 <20130624192616.GB24827@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130624192616.GB24827@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:26:16PM +0200, Borislav Petkov wrote:
> On Mon, Jun 24, 2013 at 11:48:30AM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 11, 2013 at 06:42:29PM +0200, Robert Richter wrote:
> > > +int perf_add_persistent_event_by_id(int id)
> > > +{
> > > +	struct perf_event_attr *attr;
> > > +
> > > +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> > > +	if (!attr)
> > > +		return -ENOMEM;
> > > +
> > > +	attr->sample_period	= 1;
> > > +	attr->wakeup_events	= 1;
> > > +	attr->sample_type	= PERF_SAMPLE_RAW;
> > > +	attr->persistent	= 1;
> > > +	attr->config		= id;
> > > +	attr->type		= PERF_TYPE_TRACEPOINT;
> > > +	attr->size		= sizeof(*attr);
> > > +
> > > +	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
> > > +}
> > 
> > I would call this what it is: perf_add_persistent_tracepoint(), or so
> > :-)
> 
> While we're at it, can we agree on a shortened variant for "persistent"
> - it is too much to type and makes function names uglily¹ long.

Elsewhere in this series you use 'pers' to shorten things; it reads a
bit odd to me because 'pers' is the Dutch word for press (both meanings
transfer) but that is just something I'll have to live with isn't it ;-)

As for tracepoint, it seems common to shorten that to tp; which always
reminds me of toilet paper, but I suppose more people suffer from that.

Yielding: perf_add_pers_tp() 

which I read as adding pressed toilet paper.. a well :-)
