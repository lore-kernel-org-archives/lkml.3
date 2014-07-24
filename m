Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbaGXKGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934908AbaGXKGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:06:40 -0400
Date: Thu, 24 Jul 2014 12:06:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/52] perf tools: Add perf_pmu__scan_file()
Message-ID: <20140724100606.GA1127@krava.brq.redhat.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-14-git-send-email-adrian.hunter@intel.com>
 <20140722190901.GC29750@krava.redhat.com>
 <53CF5531.90709@intel.com>
 <20140723093638.GA1207@krava.brq.redhat.com>
 <20140723142525.GM20303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723142525.GM20303@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:25:25AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 23, 2014 at 11:36:38AM +0200, Jiri Olsa escreveu:
> > On Wed, Jul 23, 2014 at 09:24:49AM +0300, Adrian Hunter wrote:
> > > On 07/22/2014 10:09 PM, Jiri Olsa wrote:
> > > > On Tue, Jul 22, 2014 at 04:17:22PM +0300, Adrian Hunter wrote:
> > > > 
> > > > SNIP
> > > > 
> > > >> +
> > > >> +static FILE *perf_pmu__open_file(struct perf_pmu *pmu, const char *name)
> > > >> +{
> > > >> +	struct stat st;
> > > >> +	char path[PATH_MAX];
> > > >> +	const char *sysfs;
> > > >> +
> > > >> +	sysfs = sysfs__mountpoint();
> > > >> +	if (!sysfs)
> > > >> +		return NULL;
> > > >> +
> > > >> +	snprintf(path, PATH_MAX,
> > > >> +		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/%s", sysfs, pmu->name, name);
> > > >> +
> > > >> +	if (stat(path, &st) < 0)
> > > >> +		return NULL;
> > > >> +
> > > >> +	return fopen(path, "r");
> > > >> +}
> > > > 
> > > > looks like this function could be used in pmu_cpumask and pmu_type
> > > > and maybe others
> > > 
> > > There is existing code duplication between them.  Given the large number of
> > > patches I would say it is easier to deal with that separately.
> > 
> > ook, jirka
> 
> Is this an Acked-by: jirka?

well, while perf_pmu__open_file would be handy now, perf_pmu__scan_file
does now have any callers in the patchset..

I'm not sure whats our current policy one this ;-) as I've seen more
functions like this over this patchset, I think we should not introduce
new interface without caller

jirka
