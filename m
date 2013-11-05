Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3KEBMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:12:49 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61642 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3KEBMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:12:48 -0500
X-AuditID: 9c930179-b7c44ae000000c83-92-5278460ec10f
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<1383029621-7384-11-git-send-email-namhyung@kernel.org>
	<20131031181654.GA11208@redhat.com>
	<87y554382a.fsf@sejong.aot.lge.com> <20131104143517.GA4440@redhat.com>
Date: Tue, 05 Nov 2013 10:12:46 +0900
In-Reply-To: <20131104143517.GA4440@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 15:35:17 +0100")
Message-ID: <878ux33b3l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Mon, 4 Nov 2013 15:35:17 +0100, Oleg Nesterov wrote:
> Hi Namhyung,
>
> On 11/04, Namhyung Kim wrote:
>>
>> >>
>> >> +	if (atomic_dec_and_test(&uprobe_buffer_ref)) {
>> >> +		free_percpu(uprobe_cpu_buffer);
>> >> +		uprobe_cpu_buffer = NULL;
>> >> +	}
>> >> +
>> >>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>> >
>> > Do we really need atomic_t? probe_event_enable/disable is called under
>> > event_mutex and we rely on this fact anyway.
>>
>> Looking at the code, it seems probe_event_enable/disable() is called
>> without event_mutex when it called from sys_perf_event_open().
>
> Where?
>
> __ftrace_set_clr_event(), perf_trace_init() or perf_trace_destroy()
> hold event_mutex. We rely on this fact anyway.

Ah, you're right.  My eyes simply missed it. ;-)

Thanks,
Namhyung
