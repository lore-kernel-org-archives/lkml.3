Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaCaNN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:13:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:13:54 -0400
Date: Mon, 31 Mar 2014 15:13:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 15/28] ktap: add built-in functions and library
 (runtime/lib_*.c)
Message-ID: <20140331131353.GH22728@two.firstfloor.org>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
 <87d2h6nomj.fsf@tassilo.jf.intel.com>
 <CAGdX0WHEB7r0t_Bu6ME+gS=HxjFY9dnfn6azwyXe4U6sV7r0eQ@mail.gmail.com>
 <20140330005809.GY22728@two.firstfloor.org>
 <CAGdX0WFyuQu9bXBy-=9m=MiLBorNKr0MH9hhTvNNFYtWLg6d-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WFyuQu9bXBy-=9m=MiLBorNKr0MH9hhTvNNFYtWLg6d-g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:01:04AM +0800, Jovi Zhangwei wrote:
> On Sun, Mar 30, 2014 at 8:58 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> Maybe in future, after ktap support "include" or "require" to
> >> import user defined library in userspace.
> >
> > Can't you just have some hardcoded standard script for now that is
> > always appeneded and provides these functions?
> >
> Maybe it's fine to hardcoded just for now.
> 
> Since we are agreed on review userspace part in another schedule,
> so I will remove this ansi library from kernel part in next version.
> 
> Thanks for this suggestion.

Please do the following for the next version:

- Don't repost with all the TODOs regarding changing other
kernel parts. Just fix them.

- As others pointed out elsewhere it's too big and full featured right
now. Please find ways to define a useful "core ktap" for now with less
features. This could be dropping library parts or dropping some of the
probe types or some parts of the language. These can then be later phased
in over time. For the library it may make sense to add some module
interface and keep parts of it external for now?

- Please run as much test content as you have with all the kernel debug
options to automatically find bugs. I would at least two runs one with
lockdep/lock debugging/preempt debugging/slab/page debugging etc.
and another with kmemleak (that is exclusive with some other options)
Some of these checks may have false positives, but the messages
should be all analyzed at least, and false positives commented.

- Do similar with the static compile time checks: checkpatch,
sparse, coccinelle. There will be likely a lot more false positives
here, so it may not be feasible to check all, but should at least
eyeball the output to see if there are some obvious problems.
For sparse it would be also good to annotate the user ioctl 
parts with __user and carefully look at the warnings there,
as that is a common problem area.

-Andi
