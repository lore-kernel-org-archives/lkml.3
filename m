Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaKQDJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:09:03 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55489 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaKQDJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:09:01 -0500
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
	<54637C05.5090807@hitachi.com>
Date: Mon, 17 Nov 2014 12:08:59 +0900
In-Reply-To: <54637C05.5090807@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 13 Nov 2014 00:25:57 +0900")
Message-ID: <87oas6ttf8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 13 Nov 2014 00:25:57 +0900, Masami Hiramatsu wrote:
> (2014/11/11 22:10), Arnaldo Carvalho de Melo wrote:
>> What I meant was, what is wrong with replacing:
>> 
>>  perf cache --probe <SPEC>  # for the current kernel
>> 
>> With:
>> 
>>  perf cache --add <PROBE-SPEC> # for the current kernel
>> 
>> And have it figure out that what is being added is a probe and do the
>> right thing?
>
> As I've said previously, PROBE-SPEC can be same as FILES (imagine that a binary
> file which has same name function in the kernel.)
> Moreover, PROBE-SPEC requires the target binary(or kernel module) except for
> kernel probes. In that case, anyway we need -x or -m options with file-path
> for --add, that is very strange.
>
> e.g.
>
> For me,
>
>  perf cache --add ./binary --probe '*'
>
> looks more natural than
>
>  perf cache --add '*' -exec ./binary
>
> since in other cases(sdt/elf), we'll just do
>
>  perf cache --add ./binary

I prefer this too.  But I'd like make the 'add' part a subcommand rather
than option like we do in perf kmem/kvm/list/lock/mem/sched ...  And it
can handle multiple files at once.  What about this?

  perf cache add [--elf|--sdt|--probe <spec>] <binary> [<binary>...]


Thanks,
Namhyung
