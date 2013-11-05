Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3KEB7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:59:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44969 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KEB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:59:06 -0500
X-AuditID: 9c93016f-b7bc7ae0000010eb-a1-527850e71546
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
Date: Tue, 05 Nov 2013 10:59:02 +0900
In-Reply-To: <20131104155131.GD4440@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 16:51:31 +0100")
Message-ID: <87vc071ue1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 16:51:31 +0100, Oleg Nesterov wrote:
> On 11/04, Namhyung Kim wrote:
>> On Mon, 04 Nov 2013 17:46:41 +0900, Namhyung Kim wrote:
>> > On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
>> >> - this only allows to read the data from the same binary.
>> >
>> > Right.  This is also an unnecessary restriction.  We should be able to
>> > access data in other binary.
>>
>> Hmm.. I guess this gonna be not simple
>
> Yes ;)
>
> - perhaps it can only be
>> supported for per-process uprobe with known virtual addresses?
>
> "Known" is very limited. Even in the simplest case (like your test-case
> from from 0/13), you simply can't know the address of "int glob" if you
> compile it with "-pie -fPIC".
>
> As for other binaries (say libc) the problem is even worse, and
> randomize_va_space adds even more pain.

Hmm.. right.  We should deal with relative addresses from the base
mapping address of a binary.

>
> But in any case, I strongly believe that it doesn't make any sense to
> rely on tu->inode in get_user_vaddr().

I'll think about it more.

Thanks,
Namhyung
