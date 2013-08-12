Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3HLIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:52:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49627 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3HLIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:52:41 -0400
Date: Mon, 12 Aug 2013 10:52:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 09/14] perf: make events stream always parsable
Message-ID: <20130812085227.GA27162@twins.programming.kicks-ass.net>
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
 <1375719994-26482-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375719994-26482-10-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 07:26:29PM +0300, Adrian Hunter wrote:
> The event stream is not always parsable because the format of a sample
> is dependent on the sample_type of the selected event.  When there
> is more than one selected event and the sample_types are not the
> same then parsing becomes problematic.  A sample can be matched to its
> selected event using the ID that is allocated when the event is opened.
> Unfortunately, to get the ID from the sample means first parsing it.
> 
> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
> the ID at a fixed position so that the ID can be retrieved without
> parsing the sample.  For sample events, that is the first position
> immediately after the header.  For non-sample events, that is the last
> position.
> 
> In this respect parsing samples requires that the sample_type and ID
> values are recorded.  For example, perf tools records struct perf_event_attr
> and the IDs within the perf.data file.  Those must be read first
> before it is possible to parse samples found later in the perf.data file.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>


