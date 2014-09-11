Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaIKNhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaIKNhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:37:21 -0400
Date: Thu, 11 Sep 2014 15:37:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V5 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140911133711.GB26389@krava.brq.redhat.com>
References: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
 <1410371732-1185-2-git-send-email-kan.liang@intel.com>
 <20140911084659.GA7326@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F077015C6DF9@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077015C6DF9@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:31:48PM +0000, Liang, Kan wrote:
> 
> 
> > SNIP
> > 
> > >  	return 0;
> > >  }
> > >
> > > +static int
> > > +comp_pmu(const void *p1, const void *p2) {
> > > +	struct perf_pmu_event_symbol *pmu1 =
> > > +			(struct perf_pmu_event_symbol *) p1;
> > > +	struct perf_pmu_event_symbol *pmu2 =
> > > +			(struct perf_pmu_event_symbol *) p2;
> > > +
> > > +	return strcmp(pmu1->symbol, pmu2->symbol); }
> > > +
> > > +/*
> > > + * Read the pmu events list from sysfs
> > > + * Save it into perf_pmu_events_list
> > > + */
> > > +static void perf_pmu__parse_init(void) {
> > > +
> > > +	struct perf_pmu *pmu = NULL;
> > > +	struct perf_pmu_alias *alias;
> > > +	int len = 0;
> > > +
> > 
> > missing my previous comment being addressed:
> >
> 
> I just found it in Junk E-mail. I have no idea why. :(
>  
> > ---
> > Why do we need to call scan here? Looks like:
> >   pmu = pmu_lookup("cpu")
> > 
> > should be enough.. and could be used below as well
> > ---
> >
> 
> Could we use "perf_pmu__find" here?
> pmu_lookup is a static function.
> Also, it looks we don't need to lookup all the time if the PMU is loaded.

right, perf_pmu__find seems better

thanks,
jirka
