Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3EJNYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:24:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41409 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3EJNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:24:07 -0400
Message-ID: <518CF4D5.4070000@oracle.com>
Date: Fri, 10 May 2013 09:23:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com> <1368115089-8909-3-git-send-email-sasha.levin@oracle.com> <20130510091816.GC3039@dyad.programming.kicks-ass.net> <20130510101131.GA31152@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510101131.GA31152@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 06:11 AM, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 11:18:16AM +0200, Peter Zijlstra wrote:
>> On Thu, May 09, 2013 at 11:58:02AM -0400, Sasha Levin wrote:
>>> kernel/lockdep.c deals with validating locking scenarios for
>>> various architectures supported by the kernel. There isn't
>>> anything kernel specific going on in lockdep, and when we
>>> compare userspace to other architectures that don't have to deal
>>> with irqs such as s390, they become all too similar.
>>>
>>> We wrap kernel/lockdep.c and include/linux/lockdep.h with
>>> several headers which allow us to build and use lockdep from
>>> userspace. We don't touch the kernel code itself which means
>>> that any work done on lockdep in the kernel will automatically
>>> benefit userspace lockdep as well!
>>>
>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>> ---
>>
>> OK, this patch is a complete fail with anything not git. Please fix it so I can
>> use quilt.
> 
> So I tried patch --posix; but that makes patch unhappy too:
> 
> |--- /dev/null
> |+++ b/tools/lib/lockdep/Makefile
> --------------------------
> No file to patch.  Skipping patch.
> out of 1 hunk ignored
> can't find file to patch at input line 393
> Perhaps you used the wrong -p or --strip option?
> 
> And while patch has a --remove-empty-files it does not recognise
> --no-remove-empty-files :/
> 
> I briefly read a thread from the git mailing list where Linus and others
> discussed the various weirdness around empty files and the take away was that
> git would act differently by default. Because as Linus put it: "patch" is a
> total piece of utterly unbelievable SH*T. 
> 
> However, aside from different behaviour I don't think its that nice git-diff
> creates patches that patch cannot possibly apply right...

Wait, I'm confused. Over here, patch is fine with creating empty files:

lappy lockdep # touch test.c
lappy lockdep # git diff /dev/null test.c > test.patch
lappy lockdep # rm test.c
lappy lockdep # file test.c
test.c: ERROR: cannot open `test.c' (No such file or directory)
lappy lockdep # patch -i test.patch
patching file test.c
lappy lockdep # file test.c
test.c: empty
lappy lockdep # cat test.patch
diff --git a/tools/lib/lockdep/test.c b/tools/lib/lockdep/test.c
new file mode 100644
index 0000000..e69de29
lappy lockdep #

So it seems that here patch would cleanly create empty files, what does quilt
do differently?


Thanks,
Sasha
