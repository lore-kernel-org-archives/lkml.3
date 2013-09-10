Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3IJUQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:16:45 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:59282 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3IJUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:16:44 -0400
Date: Tue, 10 Sep 2013 17:16:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130910201637.GB1866@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
 <20130910130002.GD28428@ghostprotocols.net>
 <CABPqkBRgj71D8FkWtR-4K8g5ErWMt8YsV7FcmxQ3Uouj640Z0A@mail.gmail.com>
 <20130910131728.GE28428@ghostprotocols.net>
 <20130910195847.GA1866@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910195847.GA1866@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 10, 2013 at 04:58:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> So we must have the handling we have for other things that were added
> in the past, like .sample_id_all, .exclude_guest, etc, like is done in
> the attached patch, please ack.
> 
> Ingo, since you haven't merged my latest perf/urgent pull req, do you
> want me to fold this into the patch that makes the tooling side use
> PERF_RECORD_MMAP2?
> 
> - Arnaldo


Also there was this minor thing I'll have in this patch too:

@@ -1926,6 +1932,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
                if_print(exclude_hv);
                if_print(exclude_idle);
                if_print(mmap);
+               if_print(mmap2);
                if_print(comm);
                if_print(freq);
                if_print(inherit_stat);
