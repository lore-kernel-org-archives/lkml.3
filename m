Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaE3CLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:11:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54567 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3CLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:11:23 -0400
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
	<87oayhh2j6.fsf@sejong.aot.lge.com>
	<20140529083732.GA1177@krava.brq.redhat.com>
Date: Fri, 30 May 2014 11:11:20 +0900
In-Reply-To: <20140529083732.GA1177@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 29 May 2014 10:37:32 +0200")
Message-ID: <87oaygf22f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 29 May 2014 10:37:32 +0200, Jiri Olsa wrote:
> On Thu, May 29, 2014 at 09:06:05AM +0900, Namhyung Kim wrote:
>> On Tue, 27 May 2014 09:54:36 +0200, Jiri Olsa wrote:
>> > On Tue, May 27, 2014 at 10:36:44AM +0900, Namhyung Kim wrote:
>> >> On Thu, 15 May 2014 19:23:34 +0200, Jiri Olsa wrote:
>> >> > Adding test that setup test_dso_data__fd_limit and test
>> >> > dso data file descriptors are cached appropriately.
>> >> 
>> >> [SNIP]
>> >> > +static long open_files_cnt(void)
>> >> > +{
>> >> > +	char path[PATH_MAX];
>> >> > +	struct dirent *dent;
>> >> > +	DIR *dir;
>> >> > +	long nr = 0;
>> >> > +	int n;
>> >> > +
>> >> > +	n = scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
>> >> > +	TEST_ASSERT_VAL("couldn't get fd path", n < PATH_MAX);
>> >> 
>> >> Looks like an unnecessary check since the scnprintf() cannot return more
>> >> than (or equal to) PATH_MAX.
>> >
>> > once it's equal it's bad.. as the man says:
>> > "return value of size or more means that the output was  truncated"
>> 
>> Did you see "sn"printf?
>
> yes, I just double checked.. jirka

Please see "scn"printf then. :)  It does something like below..

  i = snprintf(buf, size, ...);
  return (i >= size) ? : size - 1 : i;


Thanks,
Namhyung
