Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaJBRd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:33:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:56888 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaJBRdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:33:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,640,1406617200"; 
   d="scan'208";a="608831160"
From: "Liang, Kan" <kan.liang@intel.com>
To: "'Jiri Olsa'" <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 2/3] perf tools: parse the pmu event prefix and surfix
Thread-Topic: [PATCH V6 2/3] perf tools: parse the pmu event prefix and
 surfix
Thread-Index: AQHPzfQJWPcS38JCSkWkq/xSnz0u7JwAHAwAgBz8gnA=
Date: Thu, 2 Oct 2014 17:33:07 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701604EBA@SHSMSX103.ccr.corp.intel.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
 <1410462539-5468-3-git-send-email-kan.liang@intel.com>
 <20140914132312.GA1731@krava.redhat.com>
In-Reply-To: <20140914132312.GA1731@krava.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >
> > +static int
> > +comp_pmu(const void *p1, const void *p2) {
> > +	struct perf_pmu_event_symbol *pmu1 =
> > +			(struct perf_pmu_event_symbol *) p1;
> > +	struct perf_pmu_event_symbol *pmu2 =
> > +			(struct perf_pmu_event_symbol *) p2;
> 
> please keep it on one line, like:
> 	const struct perf_pmu_event_symbol *pmu1 = p1;
> 	const struct perf_pmu_event_symbol *pmu2 = p2;
> 


Removing (struct perf_pmu_event_symbol *) will cause compiler error as below.

util/parse-events.c:877:39: error: initialization discards âconstâ qualifier from pointer target type [-Werror]
  struct perf_pmu_event_symbol *pmu1 = p1;

If we keep (struct perf_pmu_event_symbol *), we may not keep it on one line. The line will over 80 characters. There will be error from checkpatch.pl.


> > +	perf_pmu_events_list =
> > +		malloc(sizeof(struct perf_pmu_event_symbol) * len);
> 
> please keep above on one line

If so, the line will over 80 characters. There will be error from checkpatch.pl.

Kan


