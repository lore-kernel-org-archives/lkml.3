Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3HGFUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:20:01 -0400
Received: from ozlabs.org ([203.10.76.45]:53282 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab3HGFUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:20:00 -0400
Date: Wed, 7 Aug 2013 15:19:57 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
Message-ID: <20130807051957.GC19998@concordia>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
 <20130806135937.GB1068@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806135937.GB1068@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 03:59:37PM +0200, Jiri Olsa wrote:
> On Tue, Aug 06, 2013 at 11:28:05PM +1000, Michael Ellerman wrote:
> 
> SNIP
> 
> >  
> >  	while (*p) {
> > @@ -812,6 +818,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
> >  		evsel->attr.exclude_guest  = mod.eG;
> >  		evsel->exclude_GH          = mod.exclude_GH;
> >  		evsel->sample_read         = mod.sample_read;
> > +
> > +		if (evsel->leader == evsel)
> > +			evsel->attr.pinned = mod.pinned;
> 
> nitpick, we have perf_evsel__is_group_leader for this check

Ah darn, missed it.

Should I do a respin?

cheers
