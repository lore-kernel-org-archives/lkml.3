Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaKREp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:45:59 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:56972 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKREp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:45:58 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com>
	<545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com>
	<54609A8C.4050308@hitachi.com> <20141110122321.GC4468@redhat.com>
	<5461B276.50004@hitachi.com> <20141111131030.GG4468@redhat.com>
	<54637C05.5090807@hitachi.com> <87oas6ttf8.fsf@sejong.aot.lge.com>
	<20141117185857.GC2207@redhat.com>
Date: Tue, 18 Nov 2014 13:45:55 +0900
In-Reply-To: <20141117185857.GC2207@redhat.com> (Arnaldo Carvalho de Melo's
	message of "Mon, 17 Nov 2014 16:58:57 -0200")
Message-ID: <87y4r9qfp8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 17 Nov 2014 16:58:57 -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 17, 2014 at 12:08:59PM +0900, Namhyung Kim escreveu:
>> I prefer this too.  But I'd like make the 'add' part a subcommand rather
>> than option like we do in perf kmem/kvm/list/lock/mem/sched ...  And it
>> can handle multiple files at once.  What about this?
>  
>>   perf cache add [--elf|--sdt|--probe <spec>] <binary> [<binary>...]
>
> In the end we can have it both ways, i.e. if the user does just:
>
>     perf cache add something
>
> or:
>
>     perf cache add --elf something
>
> And 'something' is an ELF file, then in the first case (no --elf
> specified) it will figure it out (checking the magic number, etc) and do
> the right thing.
>
> In the second case since we're being more verbose and think we know what
> 'something' is (an ELF file) the tool can check if it indeed is an ELF
> file and if not, bail out.

Ah, that's possible.

I'm not sure what we can do if it's not an ELF file though. :)

Thanks,
Namhyung
