Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3EPCYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:24:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60659 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3EPCYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:24:12 -0400
X-AuditID: 9c930197-b7b76ae000003523-05-5194434aafe9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/15] perf ftrace: Add 'record' sub-command
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
	<1368526439-31966-10-git-send-email-namhyung@kernel.org>
	<20130515212052.GA5814@krava.redhat.com>
Date: Thu, 16 May 2013 11:24:10 +0900
In-Reply-To: <20130515212052.GA5814@krava.redhat.com> (Jiri Olsa's message of
	"Wed, 15 May 2013 23:20:52 +0200")
Message-ID: <87k3mz4q7p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 23:20:52 +0200, Jiri Olsa wrote:
> On Tue, May 14, 2013 at 07:13:53PM +0900, Namhyung Kim wrote:
>> +		raw_data = synthesize_raw_data(evsel);
>> +		if (raw_data == NULL) {
>> +			pr_err("synthesizing raw sample failed\n");
>> +			goto out_fra;
>> +		}
>> +
>> +		/*
>> +		 * start of raw data is the size of raw data excluding itself.
>> +		 */
>> +		raw_size = sizeof(u32) + (*(u32 *) raw_data);
>> +
>> +		orig_size = event.sample.header.size;
>> +		event.sample.header.size += raw_size;
>> +
>> +		err = write(perf_fd, &event.sample, orig_size);
>> +		if (err != orig_size) {
>> +			pr_err("write error occurred\n");
>> +			goto out_fra;
>> +		}
>> +
>> +		err = write(perf_fd, raw_data, raw_size);
>> +		if (err != (int)raw_size) {
>> +			pr_err("write error occurred\n");
>> +			goto out_fra;
>> +		}
>
> missing free(raw_data) ?

Argh, right!

Thanks,
Namhyung
