Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaE2AGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:06:10 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42773 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaE2AGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:06:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 13/14] perf tests: Add test for caching dso file descriptors
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-14-git-send-email-jolsa@kernel.org>
	<87d2f0huj7.fsf@sejong.aot.lge.com>
	<20140527075436.GE12920@krava.brq.redhat.com>
Date: Thu, 29 May 2014 09:06:05 +0900
In-Reply-To: <20140527075436.GE12920@krava.brq.redhat.com> (Jiri Olsa's
	message of "Tue, 27 May 2014 09:54:36 +0200")
Message-ID: <87oayhh2j6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 09:54:36 +0200, Jiri Olsa wrote:
> On Tue, May 27, 2014 at 10:36:44AM +0900, Namhyung Kim wrote:
>> On Thu, 15 May 2014 19:23:34 +0200, Jiri Olsa wrote:
>> > Adding test that setup test_dso_data__fd_limit and test
>> > dso data file descriptors are cached appropriately.
>> 
>> [SNIP]
>> > +static long open_files_cnt(void)
>> > +{
>> > +	char path[PATH_MAX];
>> > +	struct dirent *dent;
>> > +	DIR *dir;
>> > +	long nr = 0;
>> > +	int n;
>> > +
>> > +	n = scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
>> > +	TEST_ASSERT_VAL("couldn't get fd path", n < PATH_MAX);
>> 
>> Looks like an unnecessary check since the scnprintf() cannot return more
>> than (or equal to) PATH_MAX.
>
> once it's equal it's bad.. as the man says:
> "return value of size or more means that the output was  truncated"

Did you see "sn"printf?

Thanks,
Namhyung
