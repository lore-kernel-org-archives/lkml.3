Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3ARXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:03:08 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41447 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130118183030.GE4051@tassilo.jf.intel.com>
References: <1358526409-9382-1-git-send-email-eranian@google.com>
	<1358526409-9382-3-git-send-email-eranian@google.com>
	<20130118183030.GE4051@tassilo.jf.intel.com>
Date: Sat, 19 Jan 2013 00:03:05 +0100
Message-ID: <CABPqkBQyr2_KZAYSG=rv81zLMHbUPuLNWQz5VeNNyfZL0o7atg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] perf stat: add interval printing
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 7:30 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>       if (forks) {
>>               close(go_pipe[1]);
>> +             if (interval) {
>> +                     while (!waitpid(child_pid, &status, WNOHANG)) {
>> +                             ret = nanosleep(&ts, NULL);
>> +                             if (ret == 0 && interval)
>> +                                     print_interval();
>
> It would be good to make sure that if someone Ctrl-Cs
> you still print the latest interval(even if shorter)
>
Ok, I can remove the test. The interval is redundant here anyway.
Will post V4 shortly.
