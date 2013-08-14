Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3HNMyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:54:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:60659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab3HNMyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,876,1367996400"; 
   d="scan'208";a="380834793"
Message-ID: <520B7F6D.2000004@intel.com>
Date: Wed, 14 Aug 2013 16:00:29 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V11 09/15] perf: make events stream always parsable
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com> <1376484517-5339-10-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1376484517-5339-10-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/13 15:48, Adrian Hunter wrote:
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

Forgot to add Peter's ack which is here:

	http://marc.info/?l=linux-kernel&m=137629757013526&w=2
