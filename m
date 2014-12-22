Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaLVWAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:00:50 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:62349 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVWAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141222150707.GE29096@krava.brq.redhat.com>
References: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145210.GA2188@redhat.com> <20141222150707.GE29096@krava.brq.redhat.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 22 Dec 2014 23:00:27 +0100
Message-ID: <CAFo99gb-LQQEBD=jqZfBqJHu6za8bocJ7mSEGWyN5ikWkaGfSQ@mail.gmail.com>
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c: Remove some unused functions
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-22 16:07 GMT+01:00 Jiri Olsa <jolsa@redhat.com>:
> On Mon, Dec 22, 2014 at 12:52:10PM -0200, Arnaldo Carvalho de Melo wrote:
>> Em Sat, Dec 20, 2014 at 01:45:41PM +0100, Rickard Strandqvist escreveu:
>> > Removes some functions that are not used anywhere:
>> > pevent_get_any_field_val() pevent_get_common_field_val() pevent_event_fields() pevent_event_common_fields() pevent_list_events() pevent_print_event() pevent_data_event_from_type() pevent_register_trace_clock() pevent_pid_is_registered()
>> >
>> > This was partially found by using a static code analysis program called cppcheck.
>>
>> Steven, Namhyung, Jiri:
>>
>> Are you ok with me applying this patch? I'm all for it, dead code better
>> be removed, but I don't know what are your plans wrt synchronization
>> with the trace-cmd repo.
>
> I'm not aware about more porting from traceevent lib, but I'm
> guessing there's still lot of things missing..?
>
> However, if we go with the removal, this patch has same
> issue as the other one.. missing removal of functions
> used only in removed code:
>
>
>   CC FPIC  event-parse.o
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4597:13: warning: ‘is_timestamp_in_us’ defined but not used [-Wunused-function]
>  static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
>              ^
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4624:12: warning: ‘events_name_cmp’ defined but not used [-Wunused-function]
>  static int events_name_cmp(const void *a, const void *b)
>             ^
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4641:12: warning: ‘events_system_cmp’ defined but not used [-Wunused-function]
>  static int events_system_cmp(const void *a, const void *b)
>             ^
> /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4659:1: warning: ‘get_event_fields’ defined but not used [-Wunused-function]
>  get_event_fields(const char *type, const char *name,
>  ^
>   CC FPIC  event-plugin.o
>
>
> thanks,
> jirka

Hi

Sounds good!
I'll check on the warnings to.

Kind regards
Rickard Strandqvist
