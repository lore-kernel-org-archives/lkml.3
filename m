Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3KLHtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:49:39 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61516 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KLHtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:49:32 -0500
X-AuditID: 9c930197-b7c73ae0000025c6-4d-5281dd8a949b
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
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
	<20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com>
	<20131106173754.GA11299@redhat.com>
	<20131106182408.GA12922@redhat.com>
	<8761s4wprj.fsf@sejong.aot.lge.com>
	<20131108170017.GB28753@redhat.com>
Date: Tue, 12 Nov 2013 16:49:30 +0900
In-Reply-To: <20131108170017.GB28753@redhat.com> (Oleg Nesterov's message of
	"Fri, 8 Nov 2013 18:00:17 +0100")
Message-ID: <87wqkeukj9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Fri, 8 Nov 2013 18:00:17 +0100, Oleg Nesterov wrote:
> On 11/07, Namhyung Kim wrote:
>>
>> On Wed, 6 Nov 2013 19:24:08 +0100, Oleg Nesterov wrote:
>> >
>> > Note that instruction_pointer_set() is not really nice in any case,
>> > this can obviously confuse FETCH_MTD_reg("ip").
>>
>> Yes.
>>
>> >
>> > But lets ignore this. The solution is simple, we can pass/use this
>> > info via current->utask. We can either add the new member, or add
>> > a union. Or simply reuse xol_vaddr. Doesn't matter.
>>
>> Okay, I'll take a look.
>
> I guess we need the union in uprobe_task anyway... I'll send the patch
> soon.
>
> Until we have the new members in uprobe_task, you can reuse utask->vaddr,
> this is safe.
>
> IOW, you can use current->utask->vaddr instead of regs->ip (as we did
> in the previous discussin) to pass the necessary info to ->fetch().

Thanks for the info!
Namhyung
