Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3IWHnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:43:35 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:54484 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWHne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <87d2o0qb1k.fsf@sejong.aot.lge.com>
References: <CAFrcx1nMmomNJZknpmRx73umXMCdHdMjEfXC5tDPGcUdD31=nw@mail.gmail.com>
	<CAFrcx1mL4ozbprh5hAb9usopDReZNbbk6jcMS=f=SGG7N2_BUw@mail.gmail.com>
	<87d2o0qb1k.fsf@sejong.aot.lge.com>
Date: Mon, 23 Sep 2013 09:43:33 +0200
Message-ID: <CAFrcx1m5iReLf8FGM+y_Xb2YK+J4tvPTL_WAnYaHs0r1=v51pQ@mail.gmail.com>
Subject: Re: perf: cannot resolve kernel symbols
From: Jean Pihet <jean.pihet@linaro.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        ".Peter Zijlstra" <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 23 September 2013 08:58, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Jean,
>
> On Thu, 19 Sep 2013 15:24:56 +0200, Jean Pihet wrote:
>> Hi,
>>
>> Ping on this issue. Any idea or pointer.
>
> Did you build perf without libelf?
no, libelf is linked to the binary.
What is weird is that the same perf binary works ok with the distro
installed kernel and not with the self built and installed one.
I suspect something with the entries in ~/.debug/.build_id and
~/.debug/[kernel.kallsyms].

Thanks,
Jean

>
> Thanks,
> Namhyung
>
>>
>> Cheers,
>> Jean
>>
>> On 17 September 2013 14:02, Jean Pihet <jean.pihet@linaro.org> wrote:
>>> Hi,
>>>
>>> I am running the perf record and report commands, which are running OK
>>> but I do not get any kernel symbol resolved when using a built and
>>> installed kernel.
>>> Using the distro installed kernel is OK though.
>>> The setup is: Marvell ARMv7 quad core, Linaro Ubuntu release.
>>>
>>> Here are the commands in use:
>>> - perf record -g dwarf -- stress --cpu 2 --io 2 --vm 2 --timeout 1s
>>> - perf report -vvv
>>>
>>> With a vmlinux found at /lib/modules/<version>/build I get the
>>> following in the trace output:
>>> ...
>>> Looking at the vmlinux_path (6 entries long)
>>> Using /lib/modules/3.11.0-00003-g0d4d4a1/build/vmlinux for symbols
>>> ...
>>> dso: [kernel.kallsyms]
>>> (/lib/modules/3.11.0-00003-g0d4d4a1/build/vmlinux, Functions, loaded,
>>> 0000000000000000000000000000000000000000)
>>>  c00081c0-c00081c3 g asm_do_IRQ
>>> ...
>>> dso: [kernel.kallsyms].head.text ([kernel.kallsyms], Functions, loaded, 00000000
>>> 00000000000000000000000000000000)
>>>  c0008000-c0008077 g stext
>>>  c0008000-c0008000 g _text
>>>  c0008084-c0008127 l __create_page_tables
>>> ...
>>> dso: [kernel.kallsyms].init.text ([kernel.kallsyms], Functions, loaded, 00000000
>>> 00000000000000000000000000000000)
>>>  c04f3260-c04f32af l __fixup_smp
>>>
>>>
>>> Without any vmlinux found I get the following:
>>> ...
>>> Looking at the vmlinux_path (6 entries long)
>>> Using /proc/kallsyms for symbols
>>> ...
>>> dso: [kernel.kallsyms] ([kernel.kallsyms], Functions, loaded,
>>> 0000000000000000000000000000000000000000)
>>>  0-beffffff l __vectors_start
>>> dso: [kernel.kallsyms] ([kernel.kallsyms], Variables, NOT loaded,
>>> 0000000000000000000000000000000000000000)
>>> dso: stress (/usr/bin/stress, Functions, loaded,
>>> bdf57306ab106fb0ce9835c95dae5b173f238b61)
>>> ...
>>>
>>>
>>> In any case the symbols are not resolved although vmlinux contains
>>> symbols and /proc/kallsyms is accessible and working correctly.
>>> Any idea on where to look at? I guess the problem is in the kernel installation.
>>>
>>> Thx & regards,
>>> Jean
