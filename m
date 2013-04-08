Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245Ab3DHJ3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:29:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38964 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762731Ab3DHJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:29:32 -0400
Message-ID: <51628DF8.6030102@hitachi.com>
Date: Mon, 08 Apr 2013 18:29:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless local_save_flags/preempt_count
 calls
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com>
In-Reply-To: <20130405150110.GA31300@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/06 0:01), Oleg Nesterov wrote:
> On 04/05, Masami Hiramatsu wrote:
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thanks!
> 
> Masami, perhaps you can also answer the question I asked in 0/4
> marc.info/?l=linux-kernel&m=136458107403835 ?
> 
> 	Off-topic question... Why uprobe_perf_func() passes "addr = ip" to
> 	perf_trace_buf_submit() ? This just sets perf_sample_data->addr for
> 	PERF_SAMPLE_ADDR, do we really need this? and we already have
> 	perf_sample_data->ip initialized by perf.
>
> kprobe_perf_func() and kretprobe_perf_func() do the same.
>

Good catch! I guess that I might misunderstood that it was used
for sampling execution address. It should be replaced with (u64)0,
as perf_trace_##call() does.

> Once again, I am just curious and this is completely offtopic.

Thank you :)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


