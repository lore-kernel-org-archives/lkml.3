Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaGICOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:14:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54214 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGICOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:14:00 -0400
Date: Tue, 8 Jul 2014 19:13:12 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/9] perf, tools: Automatically look for event file name
 for cpu v3
Message-ID: <20140709021312.GA25311@us.ibm.com>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <1402700580-26939-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402700580-26939-5-git-send-email-andi@firstfloor.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070902-1542-0000-0000-000003223678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen [andi@firstfloor.org] wrote:

| +static const char *json_default_name(void)
| +{
| +	char *cache;
| +	char *idstr = get_cpu_str();
| +	char *res = NULL;
| +	char *home = NULL;
| +	char *emap;
| +
| +	emap = getenv("EVENTMAP");
| +	if (emap) {
| +		if (access(emap, R_OK) == 0)
| +			return emap;
| +		if (asprintf(&idstr, "%s-core", emap) < 0)
| +			return NULL;
| +	}

Hi Andi,

Couple of questions/comments about EVENTMAP and the "core" suffix.

Is EVENTMAP a new environment variable ? If specific to PERF, should
we prefix it with "PERF_" to avoid collision?

Would all/many architectures need this "-core" suffix or is that Intel
specific ?

Is the intent that architectures that don't need this should simply
never set EVENTMAP variable ?

| +
| +	cache = getenv("XDG_CACHE_HOME");
| +	if (!cache) {
| +		home = getenv("HOME");
| +		if (!home || asprintf(&cache, "%s/.cache", home) < 0)
| +			goto out;
| +	}

As with XDG_CACHE_HOME in perf-download.txt, can you please add a note
about usage of EVENTMAP in the man page.

| +	if (cache && idstr)
| +		res = mkpath("%s/pmu-events/%s.json",
| +			     cache,
| +			     idstr);
| +	if (home)
| +		free(cache);
| +out:
| +	free(idstr);
| +	return res;
| +}
| +

