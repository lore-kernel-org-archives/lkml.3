Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3EFRym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab3EFRyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:54:41 -0400
Date: Mon, 6 May 2013 19:54:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tests: Add automated tests for formula object
Message-ID: <20130506175401.GD4562@krava.brq.redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
 <1367421346-18257-7-git-send-email-jolsa@redhat.com>
 <5183D52D.7060303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5183D52D.7060303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 09:18:05AM -0600, David Ahern wrote:
> On 5/1/13 9:15 AM, Jiri Olsa wrote:
> >+static int __test_basics(char *file)
> >+{
> >+	struct perf_formula fml;
> >+	struct perf_formula_set *set;
> >+	struct perf_formula_counter *counter;
> >+	struct perf_evlist *evlist;
> >+	struct perf_evsel *evsel;
> >+	struct perf_counts *counts;
> >+	struct perf_formula_expr expr;
> >+	int ret;
> >+
> >+	pr_debug("file %s\n", file);
> >+
> >+	perf_formula__init(&fml);
> >+
> >+	ret = perf_formula__load(&fml, file);
> >+	TEST_ASSERT_VAL("failed to load formula", !ret);
> 
> With all the asserts when something goes wrong you should delete the
> file right after perf_formula__load. so maybe
> 
> file = file_get(data, sizeof(data));
> ret = perf_formula__load(&fml, file);
> file_put(file);

hum, the TEST_ASSERT_VAL call 'return' from __test_basics on error and
that goes back to test_basics where file_put is called..

thanks,
jirka
