Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaIKNcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:32:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:36879 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaIKNcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384725272"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V5 2/3] perf tools: parse the pmu event prefix and surfix
Thread-Topic: [PATCH V5 2/3] perf tools: parse the pmu event prefix and
 surfix
Thread-Index: AQHPzSCSmS9bwFjEk0yqARYzBLKY0Zv7GYiAgADS4XA=
Date: Thu, 11 Sep 2014 13:31:48 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077015C6DF9@SHSMSX103.ccr.corp.intel.com>
References: <1410371732-1185-1-git-send-email-kan.liang@intel.com>
 <1410371732-1185-2-git-send-email-kan.liang@intel.com>
 <20140911084659.GA7326@krava.brq.redhat.com>
In-Reply-To: <20140911084659.GA7326@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> SNIP
> 
> >  	return 0;
> >  }
> >
> > +static int
> > +comp_pmu(const void *p1, const void *p2) {
> > +	struct perf_pmu_event_symbol *pmu1 =
> > +			(struct perf_pmu_event_symbol *) p1;
> > +	struct perf_pmu_event_symbol *pmu2 =
> > +			(struct perf_pmu_event_symbol *) p2;
> > +
> > +	return strcmp(pmu1->symbol, pmu2->symbol); }
> > +
> > +/*
> > + * Read the pmu events list from sysfs
> > + * Save it into perf_pmu_events_list
> > + */
> > +static void perf_pmu__parse_init(void) {
> > +
> > +	struct perf_pmu *pmu = NULL;
> > +	struct perf_pmu_alias *alias;
> > +	int len = 0;
> > +
> 
> missing my previous comment being addressed:
>

I just found it in Junk E-mail. I have no idea why. :(
 
> ---
> Why do we need to call scan here? Looks like:
>   pmu = pmu_lookup("cpu")
> 
> should be enough.. and could be used below as well
> ---
>

Could we use "perf_pmu__find" here?
pmu_lookup is a static function.
Also, it looks we don't need to lookup all the time if the PMU is loaded.
 
Thanks,
Kan

> or commented why not to do it..
> 
> jirka
> 

