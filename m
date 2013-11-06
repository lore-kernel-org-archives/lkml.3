Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3KFIbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:31:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48068 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3KFIbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:31:02 -0500
X-AuditID: 9c930197-b7c0bae0000007bd-53-5279fe4452f7
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
	<20131104150112.GC4440@redhat.com> <87zjpj1unj.fsf@sejong.aot.lge.com>
	<20131105162820.GA2460@redhat.com>
Date: Wed, 06 Nov 2013 17:31:00 +0900
In-Reply-To: <20131105162820.GA2460@redhat.com> (Oleg Nesterov's message of
	"Tue, 5 Nov 2013 17:28:20 +0100")
Message-ID: <87d2mex77f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Tue, 5 Nov 2013 17:28:20 +0100, Oleg Nesterov wrote:
> On 11/05, Namhyung Kim wrote:
>>
>> On Mon, 4 Nov 2013 16:01:12 +0100, Oleg Nesterov wrote:
>> > Or the syntax should be "name=probe @file/addr" or something like this.
>>
>> Okay.  Let's call this kind of thing "cross-fetch" (or a better name can
>> be suggested).
>
> Yes ;) and I am afraid there was some confusion in our discussion.
> I probably confused "probe other binaries" with cross-fetch and vice
> versa sometimes.

Sorry for not being clear enough.

>
>> > So far I think that trace_uprobes.c should not play games with vma. At all.
>>
>> Yes, playing with vma is fragile.  But otherwise how can we get the
>> address from the file+offset in random processes?
>
> Yes, this is not as simple as I thought.
>
> Let me repeat, somehow I completely forgot we need to probe other (libc)
> binaries (not only the executable itself) and dump the data from that
> binary. That is why I wrongly thought that that ->start_data trick can
> work.
>
> OK, I see other emails from you. Perhaps we can rely on instruction_pointer(),
> (I'll write more emails on this), But if not, then we probably need tu->inode
> and vma games in fetch/get_user_vaddr(). I'd still like to avoid this, if
> possible, but I am no longer sure.

Yes, I think it'll be necessary for the cross-fetch anyway.

Thanks,
Namhyung
