Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaKRLQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:16:21 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42422 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:16:20 -0500
Message-ID: <546B2A7C.5040908@hitachi.com>
Date: Tue, 18 Nov 2014 20:16:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <54609A8C.4050308@hitachi.com> <20141110122321.GC4468@redhat.com> <5461B276.50004@hitachi.com> <20141111131030.GG4468@redhat.com> <54637C05.5090807@hitachi.com> <87oas6ttf8.fsf@sejong.aot.lge.com> <546968CB.1070802@hitachi.com> <546A71FE.5080500@hitachi.com> <87tx1xqfg1.fsf@sejong.aot.lge.com>
In-Reply-To: <87tx1xqfg1.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/18 13:51), Namhyung Kim wrote:
> On Tue, 18 Nov 2014 07:09:02 +0900, Masami Hiramatsu wrote:
>> (2014/11/17 12:17), Masami Hiramatsu wrote:
>>> (2014/11/17 12:08), Namhyung Kim wrote:
>>>> I prefer this too.  But I'd like make the 'add' part a subcommand rather
>>>> than option like we do in perf kmem/kvm/list/lock/mem/sched ...  And it
>>>> can handle multiple files at once.  What about this?
>>>>
>>>>   perf cache add [--elf|--sdt|--probe <spec>] <binary> [<binary>...]
>>>
>>> OK, that's good to me. And I think --elf/--sdt is meaningless.
>>> Only --probe option is required, since we can scan the elf file to
>>> add sdt cache when adding elf binary :)
>>
>> BTW, what should we do if we put the probe cache on current running kernel?
>>
>> perf cache add --probe <probe-spec>
>>
>> and have no binary argument, is it OK?
> 
> Hmm.. what about passing /proc/kallsyms and/or /boot/vmlinux for that?

Yeah, but I think it is just optional (as same as perf probe's -k option),
we can skip that too.

> Now I found that we need to special-case the kallsyms non-ELF file :)

So, I wonder that we'd better use "bu/ildid/dso" instead of "bu/ildid/elf".

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


