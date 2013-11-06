Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3KFIhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:37:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57321 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:37:05 -0500
X-AuditID: 9c930179-b7cdfae0000019c2-64-5279ffae4641
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
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<20131104185754.GA16428@redhat.com>
	<8761s71rxw.fsf@sejong.aot.lge.com> <20131105164102.GC2460@redhat.com>
Date: Wed, 06 Nov 2013 17:37:02 +0900
In-Reply-To: <20131105164102.GC2460@redhat.com> (Oleg Nesterov's message of
	"Tue, 5 Nov 2013 17:41:02 +0100")
Message-ID: <874n7qx6xd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 17:41:02 +0100, Oleg Nesterov wrote:
> On 11/05, Namhyung Kim wrote:
>>
>> On Mon, 4 Nov 2013 19:57:54 +0100, Oleg Nesterov wrote:
>> >>
>> >> 	static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr)
>> >> 	{
>> >> 		return (void __force __user *)addr + instruction_pointer(regs);
>> >> 	}
>> >>
>> >> ?
>> >>
>> >> This should solve the problems with relocations/randomization/bss.
>> >>
>> >> The obvious disadvantage is that it is not easy to calculate the
>> >> offset we need to pass as an argument, it depends on the probed
>> >> function.
>> >
>> > forgot to mention... and instruction_pointer() can't work in ret-probe,
>> > we need to pass the "unsigned long func" arg somehow...
>>
>> Hmm.. what's the value of tu->offset in this case?  Does it have the
>> offset of the return address or the start of the function?
>
> It is the offest of function. IOW, it is the same regardless of
> is_ret_probe().

Ah, okay.  Thanks for the info.  Then yes, it'd probably better to pass
the func rather than regs since it's the only info we need, right?

Thanks,
Namhyung
