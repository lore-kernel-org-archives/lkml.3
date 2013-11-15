Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3KOWwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:52:18 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60383 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3KOWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311151007340.15200@pianoman.cluster.toy>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
	<20131115063457.GB12442@gmail.com>
	<alpine.DEB.2.02.1311151007340.15200@pianoman.cluster.toy>
Date: Fri, 15 Nov 2013 23:52:10 +0100
Message-ID: <CABPqkBQHyWUGkeu=ctGifDegUq_7oA_iFRdS-02qoGifY63F9Q@mail.gmail.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 4:08 PM, Vince Weaver <vince@deater.net> wrote:
> On Fri, 15 Nov 2013, Ingo Molnar wrote:
>>
>> Btw., does the kernel side currently support discovery of such
>> impossible group scheduling constraints at group setup time? If not
>> then it probably should and it should reject them straight away.
>
> It does not, or at least I'm pretty sure it can't if the NMI watchdog is
> enabled (Stephane, are you doing your tests with NMI watchdog disabled?)
>
I think my tests were with watchdog disabled.

> This is a big problem with PAPI.  If the NMI watchdog is enabled you can't
> tell if a group will fail until the first read, the kernel can't tell you
> at setup time.
>
Unless, you build the group and measure in for a short bit of time to validate
runtime execution. But then there is no guarantee either. Because the
perf_events
situation may change, e.g., you may get another pinned event. So I don't think
you will ever get that guarantee at setup time. I goes back to the core design
idea behind perf_events.
