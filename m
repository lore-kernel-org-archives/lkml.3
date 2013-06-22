Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3FVLp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 07:45:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3FVLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 07:45:26 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MIoFJYSRGoYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0ytn0xNaxVYA:10 a=Dpj0UFl6rbHliy2tjoIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371901523.18733.139.camel@gandalf.local.home>
Subject: Re: [PATCH 03/11] tracing: add soft disable for syscall events
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        masami.hiramatsu.pt@hitachi.com, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Sat, 22 Jun 2013 07:45:23 -0400
In-Reply-To: <CACV3sbJcgQbLdjypvRPL3cU+cki5bzinpnyy2ESmS5mLPvPVHA@mail.gmail.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <dd9d5f3d3781d1074bf554a473d49648dc79b359.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C3F866.4080705@huawei.com>
	 <1371846146.18733.126.camel@gandalf.local.home>
	 <CACV3sbJcgQbLdjypvRPL3cU+cki5bzinpnyy2ESmS5mLPvPVHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-22 at 13:08 +0800, Jovi Zhang wrote:

> > I would really like to make these smaller. They are made for every
> > system call, and I consider tracing to always be added overhead. I hate
> > it when we waste more memory for tracing as very few people use it
> > (compared to those that use Linux).
> >
> > Is it possible to allocate this only when its first used?
> >
> > -- Steve
> 
> I think the answer is yes.
> 
> Compare with link ftrace_event_file with static syscall_metadata, another option
> is put into structure trace_array, just like enabled_enter_syscalls and
> enabled_exit_syscalls BITMAP already in there
> (need change to dynamic allocated NR_syscalls array, just keep a
> pointer in trace_array).
> 
> Then in this way, there don't have any extra size overhead for static
> syscall_metadata,
> but need to allocate a array with NR_syscalls elements when first use
> syscall tracing.
> 
> which option do you prefer? steven.

Hey, if it only allocates when tracing is used, that's a big plus.
Tracing should be treated as a drug. Just like not allowing smoking in
public places, only punish the users, not those that want to breath
fresh air.

-- Steve


