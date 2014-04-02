Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaDBBug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 21:50:36 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:60542 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaDBBuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 21:50:35 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2014 21:50:35 EDT
MIME-Version: 1.0
In-Reply-To: <20140331131353.GH22728@two.firstfloor.org>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
	<87d2h6nomj.fsf@tassilo.jf.intel.com>
	<CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
	<20140330005809.GY22728@two.firstfloor.org>
	<CAGdX0WFyuQu9bXBy-=9m=MiLBorNKr0MH9hhTvNNFYtWLg6d-g@mail.gmail.com>
	<20140331131353.GH22728@two.firstfloor.org>
Date: Wed, 2 Apr 2014 09:44:06 +0800
Message-ID: <CAGdX0WH0NVqL37Qe43WE1Lfxc5VR_7C4oA-Z0VkaKSdZazd7tQ@mail.gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library (runtime/lib_*.c)
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geoff Levand <geoff@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 9:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Mar 31, 2014 at 10:01:04AM +0800, Jovi Zhangwei wrote:
>> On Sun, Mar 30, 2014 at 8:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> Maybe in future, after ktap support "include" or "require" to
>> >> import user defined library in userspace.
>> >
>> > Can't you just have some hardcoded standard script for now that is
>> > always appeneded and provides these functions?
>> >
>> Maybe it's fine to hardcoded just for now.
>>
>> Since we are agreed on review userspace part in another schedule,
>> so I will remove this ansi library from kernel part in next version.
>>
>> Thanks for this suggestion.
>
> Please do the following for the next version:
>
> - Don't repost with all the TODOs regarding changing other
> kernel parts. Just fix them.
>
Sure.

> - As others pointed out elsewhere it's too big and full featured right
> now. Please find ways to define a useful "core ktap" for now with less
> features. This could be dropping library parts or dropping some of the
> probe types or some parts of the language. These can then be later phased
> in over time. For the library it may make sense to add some module
> interface and keep parts of it external for now?
>
I will remove some library and raw tracing interface(designed for benchmark)

> - Please run as much test content as you have with all the kernel debug
> options to automatically find bugs. I would at least two runs one with
> lockdep/lock debugging/preempt debugging/slab/page debugging etc.
> and another with kmemleak (that is exclusive with some other options)
> Some of these checks may have false positives, but the messages
> should be all analyzed at least, and false positives commented.
>
ktap runs fine in lockdep/lock debugging/preempt debugging, but not
try to run in slab/page debugging and kmemleak. I will do that.

> - Do similar with the static compile time checks: checkpatch,
> sparse, coccinelle. There will be likely a lot more false positives
> here, so it may not be feasible to check all, but should at least
> eyeball the output to see if there are some obvious problems.
> For sparse it would be also good to annotate the user ioctl
> parts with __user and carefully look at the warnings there,
> as that is a common problem area.
>
Sure.

I will send out new version once we make agreement on ktap
upstream which discussing in another thread.

Thanks for these comments.

Jovi
