Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaJETCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaJETC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:02:29 -0400
Date: Sun, 5 Oct 2014 21:02:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@kernel.org
Subject: Re: [PATCH V7 2/4] perf tools: parse the pmu event prefix and suffix
Message-ID: <20141005190223.GB1934@krava.redhat.com>
References: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
 <1412352548-7603-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412352548-7603-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 12:09:06PM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>

SNIP

> +/*
> + * Read the pmu events list from sysfs
> + * Save it into perf_pmu_events_list
> + */
> +static void perf_pmu__parse_init(void)
> +{
> +
> +	struct perf_pmu *pmu = NULL;
> +	struct perf_pmu_alias *alias;
> +	int len = 0;
> +
> +	pmu = perf_pmu__find("cpu");
> +	if ((pmu == NULL) || list_empty(&pmu->aliases)) {
> +		perf_pmu_events_list_num = -1;
> +		return;
> +	}
> +	list_for_each_entry(alias, &pmu->aliases, list) {
> +		if (strchr(alias->name, '-'))
> +			len++;
> +		len++;
> +	}
> +	perf_pmu_events_list = malloc(sizeof(struct perf_pmu_event_symbol) * len);
> +	perf_pmu_events_list_num = len;

missing allocation failure check

jirka
