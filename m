Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbbAEIrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:47:24 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:48508 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbbAEIrX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Mon, 5 Jan 2015 03:47:23 -0500
Message-Id: <54AA4F9502000078000C4C46@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 05 Jan 2015 08:47:17 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <luto@amacapital.net>
Cc: <chenggang.qcg@alibaba-inc.com>, <chenggang.qin@gmail.com>,
        <dsahern@gmail.com>, <namhyung@gmail.com>, <efault@gmx.de>,
        <eranian@google.com>, <peterz@infradead.org>, <fengguang.wu@intel.com>,
        <yanmin.zhang@intel.com>, <akpm@linux-foundation.org>,
        <arjan@linux.intel.com>, <jolsa@redhat.com>, <mingo@redhat.com>,
        <paulus@samba.org>, <chenggang.qcg@taobao.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?Re:=20=E7=AD=94=E5=A4=8D=EF=BC=9A[PATCH]=20perf=20core?=
 =?UTF-8?Q?:=20Use=20KSTK=5FESP()=20instead=20of=20pt=5Fregs->sp=20while?=
 =?UTF-8?Q?=20output=20user=20regs?=
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
 <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
 <CALCETrWxPBdjY0+gCmPSwjYLB0u4Z4JgGtuR-XU=qwVzoDEBpA@mail.gmail.com>
 <CALCETrUEDuWoXyN+JrB5nWfL6B5odQJU37_y=-tzXN0vxr4tOQ@mail.gmail.com>
 <54A6C34C02000078000C4AE4@mail.emea.novell.com>
 <CALCETrUbEpTuQKiUPKeT54nFSwDQh9uA2QHLXsZeTbLrMsqxoA@mail.gmail.com>
In-Reply-To: <CALCETrUbEpTuQKiUPKeT54nFSwDQh9uA2QHLXsZeTbLrMsqxoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andy Lutomirski <luto@amacapital.net> 01/02/15 7:03 PM >>>
>On Jan 2, 2015 8:11 AM, "Jan Beulich" <jbeulich@suse.com> wrote:
>> Trying to guess what you mean by "this": A stack switch gets expressed by
>> CFI annotations just like any other frame pointer adjustments. See for example
>> the CFI_DEF_CFA_REGISTER use in the SAVE_ARGS_IRQ macro.
>>
>> If that wasn't your question, please be more precise.
>
>Sorry, my question was vague.
>
>Is there any way to consume these annotations at runtime in the
>kernel?  The goal would be for perf's NMI handler to consume the CFI
>data to figure out the userspace registers.  I'm guessing that the
>answer might be no, because we seem to be compiling with
>-fno-asynchronous-unwind-tables and we don't seem to be putting any
>.eh_frame stuff into the final kernel image.
>
>I had thought that someone implemented runtime DWARF unwinding, though.

Yes, we do have such code in our kernels, but Linus continues to veto it going
into his tree.

Jan

