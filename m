Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbaEFB7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:59:43 -0400
Received: from mail.lang.hm ([64.81.33.126]:45526 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933507AbaEFB7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:59:42 -0400
Date: Mon, 5 May 2014 18:59:29 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Jiri Kosina <jkosina@suse.cz>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
Message-ID: <alpine.DEB.2.02.1405051856340.14881@nftneq.ynat.uz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz> <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz> <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Jiri Kosina wrote:

> On Mon, 5 May 2014, David Lang wrote:
>
>> how would you know that all instances of the datastructure in memory
>> have= been touched? just because all tasks have run and are outside the
>> function in question doesn't tell you data structures have been
>> converted. You have n= o way of knowing when (or if) the next call to
>> the modified function will take place on any potential in-memory
>> structure.
>
> The problem you are trying to avoid here is functions expecting to read
> "v2" format of the data from memory, while there are still tasks that are
> unpredictably writing "v1" format of the data to the memory.
>
> There are several ways to attack this problem:
>
> - stop the whole system, convert all the existing data structures to new
>  format (which might potentially be non-trivial, mostly because you
>  have to *know* where all the data structures have been allocated), apply
>  patch, resume operation [ksplice, probably kpatch in future]
> - restrict the data format to be backwards compatible [to be done
>  manually during patch creation, currently what kGraft needs to do in
>  such case]
> - have a proxy code which can read both "v1" and "v2" formats, and writes
>  back in the same format it has seen the data structure on input

doesn't this have the same problem of finding all the data?

> - once all the *code* has been converted, it still has to understand "v1"
>  and "v2", but it can now start writing out "v2" format only [possible
>  with kGraft, not implemented in automated fashion]

which is a varient of the second one in that all the data needs to be tagged 
with a version so that it can be converted.

I don't see that 'stop the world' ends up being much better for this.

it does avoid any possibility of v1 code reading v2 data, but it doesn't help in 
avoiding v2 code reading v1 data some time (potentially much) later.

David Lang
