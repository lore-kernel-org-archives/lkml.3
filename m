Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3KSJ0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:26:46 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36867 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3KSJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:26:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131118201619.GA26312@host2.jankratochvil.net>
References: <20131118142653.GA27191@gmail.com>
	<20131118174945.GD24375@krava.brq.redhat.com>
	<20131118201619.GA26312@host2.jankratochvil.net>
Date: Tue, 19 Nov 2013 10:26:42 +0100
Message-ID: <CAFrcx1mnh2odWmzJMcKKwR=5F2dydAQctp+1LKan0w5NcFaexA@mail.gmail.com>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
From: Jean Pihet <jean.pihet@linaro.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Petr Machata <pmachata@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18 November 2013 21:16, Jan Kratochvil <jan.kratochvil@redhat.com> wrote:
> On Mon, 18 Nov 2013 18:49:45 +0100, Jiri Olsa wrote:
>> I think it's an option.. but it'll simpler to try the libdw
>> interface first and see if it's good/fast enough..
>
> The elfutils libdw unwinder is being upstreamed these weeks, the x86* unwinder
> itself is already upstream now.
Do you know about the support of AARCH64, both in 64-bit and 32-bit
(compat) mode?
I would be glad to give it a try.

>> also I recall discussing the speed with libdw developer
>
> My tests with perf using elfutils unwinder were 10x faster than libunwind;
> this is by some simple caching of ELF files.  Sure a similar cache could be
> implemented also for libunwind.  But the cache is a wrong solution.
>
> The problem is that currently perf loads the ELF files again and again for
> every process as the ELF file always gets automatically relocated for the
> address where it was loaded.  The right way is to load the ELF file only once
> and access always the same copy with process-specific displacement only.
>
> I did not investigate how much feasible it is with libunwind.  For elfutils
> there is pmachata/sharing unfinished branch from 2008 to implement that.
> I have not checked it more before the unwinder gets fully upstreamed.
>
>
> Jan

Jean

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
