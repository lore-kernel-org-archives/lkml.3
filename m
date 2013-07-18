Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab3GRMHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:07:25 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46271 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3GRMHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:07:24 -0400
Message-ID: <51E7DA79.4060505@hitachi.com>
Date: Thu, 18 Jul 2013 21:07:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing/kprobe: Wait for disabling all running
 kprobe handlers
References: <20130709082149.GK25631@dyad.programming.kicks-ass.net> <20130709093526.20138.93100.stgit@mhiramat-M0-7522> <20130715182012.GB18505@redhat.com>
In-Reply-To: <20130715182012.GB18505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/16 3:20), Oleg Nesterov wrote:
> On 07/09, Masami Hiramatsu wrote:
>>
>> Wait for disabling all running kprobe handlers when a kprobe
>> event is disabled, since the caller, trace_remove_event_call()
>> supposes that a removing event is disabled completely by
>> disabling the event.
>> With this change, ftrace can ensure that there is no running
>> event handlers after disabling it.
>>
>> Changes in V2:
>>  - Comment (in code) for clarify why we need to wait there.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Agreed.
> 
> We need this change in any case, whatever we do in trace/trace_events.c
> and in unregister_trace_probe().

Steven, I think this patch is still needed anyway even if we are
discussing file handling bugs, because this fixes another timing bug.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


