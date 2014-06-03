Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaFCNpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaFCNpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:45:07 -0400
Date: Tue, 3 Jun 2014 15:44:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/13] perf tools: Cache dso data file descriptor
Message-ID: <20140603134454.GE2864@krava.brq.redhat.com>
References: <1401743927-398-1-git-send-email-jolsa@kernel.org>
 <1401743927-398-7-git-send-email-jolsa@kernel.org>
 <538DCFFD.8030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DCFFD.8030306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:39:09AM -0600, David Ahern wrote:
> On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> >+static rlim_t get_fd_limit(void)
> >+{
> >+	struct rlimit l;
> >+	rlim_t limit = 0;
> >+
> >+	/* Allow half of the current open fd limit. */
> >+	if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
> >+		if (l.rlim_cur == RLIM_INFINITY)
> >+			limit = l.rlim_cur;
> 
> 
> Why not limit this to something reasonable -- 512 or 1024 -- rather
> "infinity" (~0UL).

hum, if there's no limit for the user at the first place
why limit him in the perf..?

jirka
