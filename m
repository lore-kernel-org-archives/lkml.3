Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3KLIAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:00:13 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44753 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3KLIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:00:04 -0500
X-AuditID: 9c930179-b7c3bae000005033-bb-5281e001e7a4
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
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
	<87a9hgwqal.fsf@sejong.aot.lge.com> <527DA997.4080306@hitachi.com>
	<20131109152313.GA14630@redhat.com>
Date: Tue, 12 Nov 2013 17:00:01 +0900
In-Reply-To: <20131109152313.GA14630@redhat.com> (Oleg Nesterov's message of
	"Sat, 9 Nov 2013 16:23:13 +0100")
Message-ID: <87siv2uk1q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg and Masami,

On Sat, 9 Nov 2013 16:23:13 +0100, Oleg Nesterov wrote:
> On 11/09, Masami Hiramatsu wrote:
>>
>> In that case, I suggest you to use "@+addr" for the relative address,
>> since that is an offset, isn't that? :)
>
> Agreed, @+addr looks better!

Looks good to me too.

>
>> BTW, it seems that @addr syntax is hard to use for uprobes, because
>> current uprobes is based on a binary, not a process, we cannot specify
>> which process is probed when we define it.
>
> Yes, exactly. That is why we suggest that user-space should pass the
> ip-relative address (actually offset). This should hopefully solve all
> problems with relocations.

Let me clarify what I understand.

For @addr syntax: kernel does no translation and uses given address

For @+addr syntax: user-space uses relative symbol address from a loaded
                   base address and kernel calculates the base address
                   using "current->utask->vaddr - tu->offset".

Is that right?

Thanks,
Namhyung
