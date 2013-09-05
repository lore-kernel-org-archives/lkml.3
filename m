Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3IENRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:17:37 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:49626 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IENRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAORVsuW-1koTMaSMgjagBz1aJ0AtvVRiM5gs3kwO2Fuvk+DhwQ@mail.gmail.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
	<1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
	<20130905124508.GE9696@mudshark.cambridge.arm.com>
	<CAORVsuW-1koTMaSMgjagBz1aJ0AtvVRiM5gs3kwO2Fuvk+DhwQ@mail.gmail.com>
Date: Thu, 5 Sep 2013 15:17:30 +0200
Message-ID: <CAKv+Gu8u4PLVfng8ru4RFwA-+Ky0vYEP3V2=vecqndo5Z0sTJg@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2013 15:05, Jean Pihet <jean.pihet@newoldbits.com> wrote:
[..]
> Here are the commands I have been using:
>  perf record -g dwarf -- <binary to profile>
>  perf report --sort symbol --call-graph --stdio
>

Ah, I failed to add the 'dwarf' after -g, however, in that case, my
perf report segfaults:

#0  locate_debug_info (as=0xb6ea9144 <local_addr_space>,
info=info@entry=0x83d6, addr=addr@entry=0, dlname=0x4a0000 <Address
0x4a0000 out of bounds>)
    at dwarf/Gfind_proc_info-lsb.c:295
#1  0xb6e9a9c6 in _Uarm_dwarf_find_debug_frame (found=found@entry=0,
di_debug=di_debug@entry=0xbeff95b8, info=info@entry=0x83d6,
ip=ip@entry=0)
    at dwarf/Gfind_proc_info-lsb.c:423
#2  0x0006f0e4 in find_proc_info (as=0x2c06a0, ip=33750,
pi=0xbeffa8fc, need_unwind_info=1, arg=0xbeffe530) at
util/unwind.c:339
#3  0xb6e98258 in fetch_proc_info (c=c@entry=0xbeffa4d4, ip=<optimised
out>, need_unwind_info=need_unwind_info@entry=1) at
dwarf/Gparser.c:422
#4  0xb6e99640 in uncached_dwarf_find_save_locs (c=0xbeffa4d4) at
dwarf/Gparser.c:824
#5  _Uarm_dwarf_find_save_locs (c=c@entry=0xbeffa4d4) at dwarf/Gparser.c:849
#6  0xb6e9a034 in _Uarm_dwarf_step (c=c@entry=0xbeffa4d4) at dwarf/Gstep.c:34
#7  0xb6e95182 in _Uarm_step (cursor=cursor@entry=0xbeffa4d4) at arm/Gstep.c:177
#8  0x0006ed50 in get_entries (ui=ui@entry=0xbeffe530,
cb=cb@entry=0x47599 <unwind_entry>, arg=arg@entry=0xb6b804c8) at
util/unwind.c:573
#9  0x0006f324 in unwind__get_entries (cb=cb@entry=0x47599
<unwind_entry>, arg=0xb6b804c8, machine=machine@entry=0xf0544,
thread=thread@entry=0x101860,
    sample_uregs=sample_uregs@entry=65535, data=data@entry=0xbeffe740)
at util/unwind.c:608
#10 0x00049a96 in machine__resolve_callchain
(machine=machine@entry=0xf0544, evsel=evsel@entry=0xf0b98,
thread=0x101860, sample=sample@entry=0xbeffe740,
    parent=parent@entry=0xbeffe644) at util/machine.c:1262
#11 0x0001a43e in perf_evsel__add_hist_entry (machine=0xf0544,
sample=0xbeffe740, al=0xbeffe640, evsel=0xf0b98) at
builtin-report.c:256
#12 process_sample_event (tool=0xbeffeb68, event=0xb6b3c600,
sample=0xbeffe740, evsel=0xf0b98, machine=0xf0544) at
builtin-report.c:335
#13 0x0004b3ca in perf_session_deliver_event
(session=session@entry=0xf0498, event=0xb6b3c600,
sample=sample@entry=0xbeffe740, tool=tool@entry=0xbeffeb68,
    file_offset=file_offset@entry=161280) at util/session.c:873
#14 0x0004b8d0 in flush_sample_queue (s=s@entry=0xf0498,
tool=tool@entry=0xbeffeb68) at util/session.c:521
#15 0x0004c974 in __perf_session__process_events
(session=session@entry=0xf0498, data_offset=<optimised out>,
data_size=data_size@entry=437976, file_size=438264,
    tool=tool@entry=0xbeffeb68) at util/session.c:1269
#16 0x0004cc5c in perf_session__process_events
(self=self@entry=0xf0498, tool=tool@entry=0xbeffeb68) at
util/session.c:1286
#17 0x0001b4b2 in __cmd_report (rep=0xbeffeb68) at builtin-report.c:513
#18 cmd_report (argc=0, argv=0xbefff6c8, prefix=<optimised out>) at
builtin-report.c:957
#19 0x0000d80e in run_builtin (p=p@entry=0xaa548 <commands+84>,
argc=argc@entry=2, argv=argv@entry=0xbefff6c8) at perf.c:319
#20 0x0000d28a in handle_internal_command (argv=0xbefff6c8, argc=2) at
perf.c:376
#21 run_argv (argv=0xbefff4a8, argcp=0xbefff4ac) at perf.c:420
#22 main (argc=2, argv=0xbefff6c8) at perf.c:521

-- 
Ard.



>>
>> E.g. the following stupid program (built with -O0 -g):
>>
>> --->8
>>
>> void bar(void)
>> {
>>         int i;
>>         for (i = 0; i < 1000000; ++i)
>>                 asm volatile("nop" ::: "memory");
>> }
>>
>> void foo(void)
>> {
>>         bar();
>> }
>>
>>
>> int main(void)
>> {
>>         foo();
>>         return 0;
>> }
>>
>> 8<---
>>
>> Gives me an incomplete callchain:
>>
>> # Overhead   Command      Shared Object                           Symbol
>> # ........  ........  .................  ...............................
>> #
>>      0.00%  unwindme  unwindme           [.] bar
>>             |
>>             --- bar
> I get the following with a simple stupid program with a long call chain:
>      0.57%  stress_bt  stress_bt          [.] foo_115
>             |
>             --- foo_115
>                 foo_114
>                 foo_113
> ...
>                 foo_92
>                 bar
>                 doit
>                 main
>                 __libc_start_main
>
> Things to check:
> - compile the binaries and libraries with -g (-dbg flavor of libs are
> usually ok),
> - use -g dwarf in perf record
>
>
>> This is the same with or without your patch.
>>
>> Will
>
> Thanks for testing!
> Jean
>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
