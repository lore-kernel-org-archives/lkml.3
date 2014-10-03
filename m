Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJCIX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaJCIX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:23:56 -0400
Date: Fri, 3 Oct 2014 10:23:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V6 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20141003082351.GF19087@krava.brq.redhat.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
 <1410462539-5468-3-git-send-email-kan.liang@intel.com>
 <20140914132312.GA1731@krava.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701604EBA@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701604EBA@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 05:33:07PM +0000, Liang, Kan wrote:
> 
> 
> > >
> > > +static int
> > > +comp_pmu(const void *p1, const void *p2) {
> > > +	struct perf_pmu_event_symbol *pmu1 =
> > > +			(struct perf_pmu_event_symbol *) p1;
> > > +	struct perf_pmu_event_symbol *pmu2 =
> > > +			(struct perf_pmu_event_symbol *) p2;
> > 
> > please keep it on one line, like:
> > 	const struct perf_pmu_event_symbol *pmu1 = p1;
> > 	const struct perf_pmu_event_symbol *pmu2 = p2;
> > 
> 
> 
> Removing (struct perf_pmu_event_symbol *) will cause compiler error as below.
> 
> util/parse-events.c:877:39: error: initialization discards âconstâ qualifier from pointer target type [-Werror]
>   struct perf_pmu_event_symbol *pmu1 = p1;
> 
> If we keep (struct perf_pmu_event_symbol *), we may not keep it on one line. The line will over 80 characters. There will be error from checkpatch.pl.
> 
> 
> > > +	perf_pmu_events_list =
> > > +		malloc(sizeof(struct perf_pmu_event_symbol) * len);
> > 
> > please keep above on one line
> 
> If so, the line will over 80 characters. There will be error from checkpatch.pl.

AFAIK we are not that strict on this warning.. I think the current
notion is to keep the code easy to read with reasonable breakages
of this rule

jirka
