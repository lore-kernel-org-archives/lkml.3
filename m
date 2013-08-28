Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3H1Fht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:37:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43855 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3H1Fhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:37:48 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-80-521d8caafc23
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 12/13] tracing/uprobes: Add more fetch functions
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
	<1377593336-16828-13-git-send-email-namhyung@kernel.org>
	<521C9594.30901@hitachi.com>
Date: Wed, 28 Aug 2013 14:37:45 +0900
In-Reply-To: <521C9594.30901@hitachi.com> (Masami Hiramatsu's message of "Tue,
	27 Aug 2013 21:03:32 +0900")
Message-ID: <87ioyqv0ie.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 27 Aug 2013 21:03:32 +0900, Masami Hiramatsu wrote:
> (2013/08/27 17:48), Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Implement uprobe-specific stack and memory fetch functions and add
>> them to the uprobes_fetch_type_table.  Other fetch fucntions will be
>> shared with kprobes.

[SNIP]
>> +
>> +static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
>> +{
>> +	struct vm_area_struct *vma;
>> +	unsigned long addr = GET_USP(regs);
>
> I recommend you to use user_stack_pointer() rather than GET_USP here.
> Since some arch seem not to have correct GET_USP implementation (e.g. arm),
> kernel build will be failed.

Okay, I'll change to the user_stack_pointer().

>
> And at least trace_probe.c part is good for me.
>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks for your review!
Namhyung
