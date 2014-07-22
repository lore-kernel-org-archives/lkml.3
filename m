Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaGVTJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaGVTJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:09:33 -0400
Date: Tue, 22 Jul 2014 21:09:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/52] perf tools: Add perf_pmu__scan_file()
Message-ID: <20140722190901.GC29750@krava.redhat.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-14-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406035081-14301-14-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:17:22PM +0300, Adrian Hunter wrote:

SNIP

> +
> +static FILE *perf_pmu__open_file(struct perf_pmu *pmu, const char *name)
> +{
> +	struct stat st;
> +	char path[PATH_MAX];
> +	const char *sysfs;
> +
> +	sysfs = sysfs__mountpoint();
> +	if (!sysfs)
> +		return NULL;
> +
> +	snprintf(path, PATH_MAX,
> +		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/%s", sysfs, pmu->name, name);
> +
> +	if (stat(path, &st) < 0)
> +		return NULL;
> +
> +	return fopen(path, "r");
> +}

looks like this function could be used in pmu_cpumask and pmu_type
and maybe others

jirka
