Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3FXT0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:26:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58215 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3FXT0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:26:21 -0400
Date: Mon, 24 Jun 2013 21:26:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130624192616.GB24827@pd.tnic>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094830.GP28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130624094830.GP28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:48:30AM +0200, Peter Zijlstra wrote:
> On Tue, Jun 11, 2013 at 06:42:29PM +0200, Robert Richter wrote:
> > +int perf_add_persistent_event_by_id(int id)
> > +{
> > +	struct perf_event_attr *attr;
> > +
> > +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> > +	if (!attr)
> > +		return -ENOMEM;
> > +
> > +	attr->sample_period	= 1;
> > +	attr->wakeup_events	= 1;
> > +	attr->sample_type	= PERF_SAMPLE_RAW;
> > +	attr->persistent	= 1;
> > +	attr->config		= id;
> > +	attr->type		= PERF_TYPE_TRACEPOINT;
> > +	attr->size		= sizeof(*attr);
> > +
> > +	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
> > +}
> 
> I would call this what it is: perf_add_persistent_tracepoint(), or so
> :-)

While we're at it, can we agree on a shortened variant for "persistent"
- it is too much to type and makes function names uglily¹ long.


¹ look at me making up adverbs.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
