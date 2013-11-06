Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3KFSWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3KFSWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:22:52 -0500
Date: Wed, 6 Nov 2013 19:24:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131106182408.GA12922@redhat.com>
References: <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106173754.GA11299@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention,

On 11/06, Oleg Nesterov wrote:
>
> I meant,
>
> 		saved_ip = instruction_pointer(regs);
>
> 		// pass the "ip" which was used to calculate
> 		// the @addr argument to fetch_*() methods
>
> 		temp_ip = is_ret_probe(tu) ? func : saved_ip;
> 		temp_ip -= tu->offset;
> 		instruction_pointer_set(temp_ip);
>
> 		store_trace_args(...);

Note that instruction_pointer_set() is not really nice in any case,
this can obviously confuse FETCH_MTD_reg("ip").

But lets ignore this. The solution is simple, we can pass/use this
info via current->utask. We can either add the new member, or add
a union. Or simply reuse xol_vaddr. Doesn't matter.

So the only question is should we rely on instruction_pointer/func
to translate the address or we should do something else (say, vma).

So far I like this approach.

Oleg.

