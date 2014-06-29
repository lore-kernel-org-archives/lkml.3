Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaF2Qoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaF2Qoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:44:38 -0400
Date: Sun, 29 Jun 2014 18:44:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 14/18] perf tools: Add perf_config_u64 function
Message-ID: <20140629164417.GC1407@krava.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-15-git-send-email-jolsa@kernel.org>
 <53ADF953.2080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADF953.2080009@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:08:03PM -0600, David Ahern wrote:
> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> 
> >@@ -307,6 +322,15 @@ static void die_bad_config(const char *name)
> >  	die("bad config value for '%s'", name);
> >  }
> >
> >+u64 perf_config_u64(const char *name, const char *value)
> >+{
> >+	long long ret = 0;
> >+
> >+	if (!perf_parse_llong(value, &ret))
> >+		die_bad_config(name);
> >+	return (u64) ret;
> 
> 
> Thought we were not using the die functions any longer?

seem like patchset removing that for config object
will prepare separate change

jirka
