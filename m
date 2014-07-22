Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaGVTWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaGVTWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:22:49 -0400
Date: Tue, 22 Jul 2014 21:22:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 17/52] perf evlist: Add perf_evlist__set_tracking_event()
Message-ID: <20140722192206.GD29750@krava.redhat.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-18-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406035081-14301-18-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:17:26PM +0300, Adrian Hunter wrote:

SNIP

>  }
> +
> +int perf_evlist__set_tracking_event(struct perf_evlist *evlist,
> +				    struct perf_evsel *tracking_evsel)
> +{
> +	struct perf_evsel *evsel;
> +
> +	if (tracking_evsel->idx == 0)
> +		return 0;
> +
> +	if (tracking_evsel->leader->nr_members > 1)
> +		return -EINVAL;
> +
> +	list_for_each_entry(evsel, &evlist->entries, node) {
> +		if (evsel->idx < tracking_evsel->idx)
> +			evsel->idx += 1;
> +	}
> +	tracking_evsel->idx = 0;
> +
> +	return 0;
> +}

wouldnt it be better to add evsel->is_tracking bool for this?

jirka
