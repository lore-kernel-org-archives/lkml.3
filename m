Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab3AVFDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:03:43 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53288 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3AVFDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:03:42 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-62-50fe1dac453a
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        "ak\@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v4 2/2] perf stat: add interval printing
References: <1358550839-7509-1-git-send-email-eranian@google.com>
	<1358550839-7509-3-git-send-email-eranian@google.com>
	<87bocjl00m.fsf@sejong.aot.lge.com>
	<CABPqkBQD-v8aEP=cgGDw8g4jGTGMA--mK_vvs73TxtDpmcKizg@mail.gmail.com>
Date: Tue, 22 Jan 2013 14:03:40 +0900
In-Reply-To: <CABPqkBQD-v8aEP=cgGDw8g4jGTGMA--mK_vvs73TxtDpmcKizg@mail.gmail.com>
	(Stephane Eranian's message of "Mon, 21 Jan 2013 13:38:29 +0100")
Message-ID: <87txq9kdw3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, 21 Jan 2013 13:38:29 +0100, Stephane Eranian wrote:
> On Mon, Jan 21, 2013 at 3:53 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> AFAICS the only caller of print_stat() is cmd_stat() and it'll call this
>> only if interval is 0.  So why not just setting prefix to NULL then?
>>
> I don't understand your point here. Prefix is set ONLY when interval
> is non zero. Prefix is setup before print_counter() so that each counter
> for each interval is timestamped with the same value.

Please see below.


>>> -     if (status != -1)
>>> +     if (status != -1 && !interval)
>>>               print_stat(argc, argv);

Here, print_stat() is called only if interval is 0.  So no need to check
the interval inside the print_stat(), right?

Thanks,
Namhyung
