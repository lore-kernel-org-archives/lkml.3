Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaIKOxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbaIKOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:53:27 -0400
Date: Thu, 11 Sep 2014 16:53:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V5 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140911145321.GB32722@krava.brq.redhat.com>
References: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
 <1410371732-1185-2-git-send-email-kan.liang@intel.com>
 <20140911085143.GB7326@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F077015C6EDB@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077015C6EDB@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:50:50PM +0000, Liang, Kan wrote:
> 
> 
> > On Wed, Sep 10, 2014 at 01:55:31PM -0400, kan.liang@intel.com wrote:
> > 
> > SNIP
> > 
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
> > > +	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> > > +		list_for_each_entry(alias, &pmu->aliases, list) {
> > > +			if (!strcmp(pmu->name, "cpu")) {
> > > +				if (strchr(alias->name, '-'))
> > > +					len++;
> > > +				len++;
> > > +			}
> > > +	}
> > > +	if (len == 0)
> > > +		return;
> > 
> > s oif 'len' is 0 we will scan all the time? maybe we want some separate 'init'
> > variable..
> > 
> 
> Maybe we can reuse the "perf_pmu_events_list_num".
> static int perf_pmu_events_list_num;
> 
> If len is 0, we just set perf_pmu_events_list_num to -1.
> Is it OK?

seems ok

jirka
