Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3KHQ7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:59:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab3KHQ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:59:02 -0500
Date: Fri, 8 Nov 2013 18:00:17 +0100
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
Message-ID: <20131108170017.GB28753@redhat.com>
References: <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com> <20131106182408.GA12922@redhat.com> <8761s4wprj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761s4wprj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Namhyung Kim wrote:
>
> On Wed, 6 Nov 2013 19:24:08 +0100, Oleg Nesterov wrote:
> >
> > Note that instruction_pointer_set() is not really nice in any case,
> > this can obviously confuse FETCH_MTD_reg("ip").
>
> Yes.
>
> >
> > But lets ignore this. The solution is simple, we can pass/use this
> > info via current->utask. We can either add the new member, or add
> > a union. Or simply reuse xol_vaddr. Doesn't matter.
>
> Okay, I'll take a look.

I guess we need the union in uprobe_task anyway... I'll send the patch
soon.

Until we have the new members in uprobe_task, you can reuse utask->vaddr,
this is safe.

IOW, you can use current->utask->vaddr instead of regs->ip (as we did
in the previous discussin) to pass the necessary info to ->fetch().

Oleg.

