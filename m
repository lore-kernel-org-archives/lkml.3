Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3AVNIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:08:14 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45550 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3AVNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <87txq9kdw3.fsf@sejong.aot.lge.com>
References: <1358550839-7509-1-git-send-email-eranian@google.com>
	<1358550839-7509-3-git-send-email-eranian@google.com>
	<87bocjl00m.fsf@sejong.aot.lge.com>
	<CABPqkBQD-v8aEP=cgGDw8g4jGTGMA--mK_vvs73TxtDpmcKizg@mail.gmail.com>
	<87txq9kdw3.fsf@sejong.aot.lge.com>
Date: Tue, 22 Jan 2013 14:08:12 +0100
Message-ID: <CABPqkBSQuJ1YWmp-MmYjsm-D-PBZT7FRZM2ttbG06GEYAnJF6A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] perf stat: add interval printing
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 6:03 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Mon, 21 Jan 2013 13:38:29 +0100, Stephane Eranian wrote:
>> On Mon, Jan 21, 2013 at 3:53 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> AFAICS the only caller of print_stat() is cmd_stat() and it'll call this
>>> only if interval is 0.  So why not just setting prefix to NULL then?
>>>
>> I don't understand your point here. Prefix is set ONLY when interval
>> is non zero. Prefix is setup before print_counter() so that each counter
>> for each interval is timestamped with the same value.
>
> Please see below.
>
>
>>>> -     if (status != -1)
>>>> +     if (status != -1 && !interval)
>>>>               print_stat(argc, argv);
>
> Here, print_stat() is called only if interval is 0.  So no need to check
> the interval inside the print_stat(), right?
>
Ok, got it. Due to some leftover code. Will fix in V6.
Thanks.
