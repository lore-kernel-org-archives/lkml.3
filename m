Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaLVPHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:07:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaLVPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:07:14 -0500
Date: Mon, 22 Dec 2014 16:07:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, acme@kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Remove some
 unused functions
Message-ID: <20141222150707.GE29096@krava.brq.redhat.com>
References: <1419079541-32288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145210.GA2188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141222145210.GA2188@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:52:10PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Sat, Dec 20, 2014 at 01:45:41PM +0100, Rickard Strandqvist escreveu:
> > Removes some functions that are not used anywhere:
> > pevent_get_any_field_val() pevent_get_common_field_val() pevent_event_fields() pevent_event_common_fields() pevent_list_events() pevent_print_event() pevent_data_event_from_type() pevent_register_trace_clock() pevent_pid_is_registered()
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> 
> Steven, Namhyung, Jiri:
> 
> Are you ok with me applying this patch? I'm all for it, dead code better
> be removed, but I don't know what are your plans wrt synchronization
> with the trace-cmd repo.

I'm not aware about more porting from traceevent lib, but I'm
guessing there's still lot of things missing..?

However, if we go with the removal, this patch has same
issue as the other one.. missing removal of functions
used only in removed code:


  CC FPIC  event-parse.o
/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4597:13: warning: ‘is_timestamp_in_us’ defined but not used [-Wunused-function]
 static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
             ^
/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4624:12: warning: ‘events_name_cmp’ defined but not used [-Wunused-function]
 static int events_name_cmp(const void *a, const void *b)
            ^
/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4641:12: warning: ‘events_system_cmp’ defined but not used [-Wunused-function]
 static int events_system_cmp(const void *a, const void *b)
            ^
/home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/event-parse.c:4659:1: warning: ‘get_event_fields’ defined but not used [-Wunused-function]
 get_event_fields(const char *type, const char *name,
 ^
  CC FPIC  event-plugin.o


thanks,
jirka
