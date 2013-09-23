Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3IWG6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:58:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60727 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3IWG6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:58:32 -0400
X-AuditID: 9c930179-b7c8bae000006c65-8a-523fe697b2fb
From: Namhyung Kim <namhyung@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        ".Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: perf: cannot resolve kernel symbols
References: <CAFrcx1nMmomNJZknpmRx73umXMCdHdMjEfXC5tDPGcUdD31=nw@mail.gmail.com>
	<CAFrcx1mL4ozbprh5hAb9usopDReZNbbk6jcMS=f=SGG7N2_BUw@mail.gmail.com>
Date: Mon, 23 Sep 2013 15:58:31 +0900
In-Reply-To: <CAFrcx1mL4ozbprh5hAb9usopDReZNbbk6jcMS=f=SGG7N2_BUw@mail.gmail.com>
	(Jean Pihet's message of "Thu, 19 Sep 2013 15:24:56 +0200")
Message-ID: <87d2o0qb1k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, 19 Sep 2013 15:24:56 +0200, Jean Pihet wrote:
> Hi,
>
> Ping on this issue. Any idea or pointer.

Did you build perf without libelf?

Thanks,
Namhyung

>
> Cheers,
> Jean
>
> On 17 September 2013 14:02, Jean Pihet <jean.pihet@linaro.org> wrote:
>> Hi,
>>
>> I am running the perf record and report commands, which are running OK
>> but I do not get any kernel symbol resolved when using a built and
>> installed kernel.
>> Using the distro installed kernel is OK though.
>> The setup is: Marvell ARMv7 quad core, Linaro Ubuntu release.
>>
>> Here are the commands in use:
>> - perf record -g dwarf -- stress --cpu 2 --io 2 --vm 2 --timeout 1s
>> - perf report -vvv
>>
>> With a vmlinux found at /lib/modules/<version>/build I get the
>> following in the trace output:
>> ...
>> Looking at the vmlinux_path (6 entries long)
>> Using /lib/modules/3.11.0-00003-g0d4d4a1/build/vmlinux for symbols
>> ...
>> dso: [kernel.kallsyms]
>> (/lib/modules/3.11.0-00003-g0d4d4a1/build/vmlinux, Functions, loaded,
>> 0000000000000000000000000000000000000000)
>>  c00081c0-c00081c3 g asm_do_IRQ
>> ...
>> dso: [kernel.kallsyms].head.text ([kernel.kallsyms], Functions, loaded, 00000000
>> 00000000000000000000000000000000)
>>  c0008000-c0008077 g stext
>>  c0008000-c0008000 g _text
>>  c0008084-c0008127 l __create_page_tables
>> ...
>> dso: [kernel.kallsyms].init.text ([kernel.kallsyms], Functions, loaded, 00000000
>> 00000000000000000000000000000000)
>>  c04f3260-c04f32af l __fixup_smp
>>
>>
>> Without any vmlinux found I get the following:
>> ...
>> Looking at the vmlinux_path (6 entries long)
>> Using /proc/kallsyms for symbols
>> ...
>> dso: [kernel.kallsyms] ([kernel.kallsyms], Functions, loaded,
>> 0000000000000000000000000000000000000000)
>>  0-beffffff l __vectors_start
>> dso: [kernel.kallsyms] ([kernel.kallsyms], Variables, NOT loaded,
>> 0000000000000000000000000000000000000000)
>> dso: stress (/usr/bin/stress, Functions, loaded,
>> bdf57306ab106fb0ce9835c95dae5b173f238b61)
>> ...
>>
>>
>> In any case the symbols are not resolved although vmlinux contains
>> symbols and /proc/kallsyms is accessible and working correctly.
>> Any idea on where to look at? I guess the problem is in the kernel installation.
>>
>> Thx & regards,
>> Jean
