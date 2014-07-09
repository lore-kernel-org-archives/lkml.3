Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaGIWVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:21:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaGIWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:21:08 -0400
Date: Thu, 10 Jul 2014 00:20:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/9] perf, tools, test: Add test case for alias and JSON
 parsing v2
Message-ID: <20140709222038.GL20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:16:03PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a simple test case to perf test that runs perf download and parses
> all the available events, including json events.
> 
> This needs adding an all event iterator to pmu.c
> 

SNIP

> +
> +int pmu_iterate_events(int (*func)(const char *name))
> +{
> +	int ret = 0;
> +	struct perf_pmu *pmu;
> +	struct perf_pmu_alias *alias;
> +
> +	perf_pmu__find("cpu"); /* Load PMUs */
> +	pmu = NULL;
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
> +		list_for_each_entry(alias, &pmu->aliases, list) {
> +			ret = func(alias->name);
> +			if (ret != 0)
> +				break;
> +		}
> +	}
> +	return ret;
> +}
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 583d21e..a8ed283 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -47,5 +47,7 @@ bool pmu_have_event(const char *pname, const char *name);
>  
>  int perf_pmu__test(void);
>  
> +int pmu_iterate_events(int (*func)(const char *name));
> +

this new pmu interface needs to go to separated patchset

jirka
