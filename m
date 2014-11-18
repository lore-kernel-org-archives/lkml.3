Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKRElM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:41:12 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54570 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaKRElK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:41:10 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <87lhnr5sbl.fsf@sejong.aot.lge.com>
	<54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com>
	<874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com>
	<545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com>
	<54609A8C.4050308@hitachi.com> <20141110122321.GC4468@redhat.com>
	<5461B276.50004@hitachi.com> <20141111131030.GG4468@redhat.com>
	<54637C05.5090807@hitachi.com> <87oas6ttf8.fsf@sejong.aot.lge.com>
	<546968CB.1070802@hitachi.com>
Date: Tue, 18 Nov 2014 13:41:08 +0900
In-Reply-To: <546968CB.1070802@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 17 Nov 2014 12:17:31 +0900")
Message-ID: <87389hruhn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Mon, 17 Nov 2014 12:17:31 +0900, Masami Hiramatsu wrote:
> (2014/11/17 12:08), Namhyung Kim wrote:
>> I prefer this too.  But I'd like make the 'add' part a subcommand rather
>> than option like we do in perf kmem/kvm/list/lock/mem/sched ...  And it
>> can handle multiple files at once.  What about this?
>> 
>>   perf cache add [--elf|--sdt|--probe <spec>] <binary> [<binary>...]
>
> OK, that's good to me. And I think --elf/--sdt is meaningless.

Maybe not :)

I'm considering the opposite side - by providing the options, we also
support the negative ones too.  So --no-elf and/or --no-sdt options are
possible.  Also the positive options can be used with del(ete)
subcommand to remove some contents selectively.

I think it'd be helpful as we sometimes don't want to do that for some
reason.  For example, current perf record adds binary (elf) files to the
cache automatically iff it's accessed.  But what about SDTs?  Should we
add SDTs at the same time?  If not, what if we try to add existing elf
files only for SDTs?

Thanks,
Namhyung


> Only --probe option is required, since we can scan the elf file to
> add sdt cache when adding elf binary :)
