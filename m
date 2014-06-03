Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaFCPfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbaFCPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:35:17 -0400
Date: Tue, 3 Jun 2014 17:35:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/13] perf tests: Allow reuse of test_file function
Message-ID: <20140603153505.GJ2864@krava.brq.redhat.com>
References: <1401743927-398-1-git-send-email-jolsa@kernel.org>
 <1401743927-398-12-git-send-email-jolsa@kernel.org>
 <538DD2E3.2090407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538DD2E3.2090407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:51:31AM -0600, David Ahern wrote:
> On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> >Making the test_file function to be reusable for
> >new tests coming in following patches.
> >
> >Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> >Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> >Cc: David Ahern <dsahern@gmail.com>
> >Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >Cc: Ingo Molnar <mingo@kernel.org>
> >Cc: Jean Pihet <jean.pihet@linaro.org>
> >Cc: Namhyung Kim <namhyung@kernel.org>
> >Cc: Paul Mackerras <paulus@samba.org>
> >Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >---
> >  tools/perf/tests/dso-data.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> >diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
> >index 3e6cb17..f5c8743 100644
> >--- a/tools/perf/tests/dso-data.c
> >+++ b/tools/perf/tests/dso-data.c
> >@@ -12,11 +12,15 @@
> >
> >  static char *test_file(int size)
> >  {
> >-	static char buf_templ[] = "/tmp/test-XXXXXX";
> >+#define TEMPL "/tmp/test-XXXXXX"
> 
> use /tmp/perf-test-XXXXXX or /tmp/perf-XXXXXX to we know where all
> these tmp files came from.

ok

> 
> >+	static char buf_templ[sizeof(TEMPL)];
> 
> why static? and ...

I need to use it outside the test_file function

> 
> >  	char *templ = buf_templ;
> >  	int fd, i;
> >  	unsigned char *buf;
> >
> >+	strcpy(buf_templ, TEMPL);
> >+#undef TEMPL
> 
> why the need to change from char buf_templ[] to strcpy?

because it gets overwritten via mkstemp function

thanks,
jirka
