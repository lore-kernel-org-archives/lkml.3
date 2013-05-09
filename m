Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3EIMnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:43:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3EIMnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:43:33 -0400
Message-ID: <518B99C0.9010304@oracle.com>
Date: Thu, 09 May 2013 08:42:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] liblockdep: userspace lockdep
References: <1368073156-27567-1-git-send-email-sasha.levin@oracle.com> <20130509085429.GA3039@dyad.programming.kicks-ass.net>
In-Reply-To: <20130509085429.GA3039@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 04:54 AM, Peter Zijlstra wrote:
> On Thu, May 09, 2013 at 12:19:07AM -0400, Sasha Levin wrote:
>> liblockdep is a tiny wrapper built around kernel/lockdep.c. The aim is to
>> provide the same functionality the kernel gets from lockdep to userspace.
>>
>> The bulk of the code here is the LD_PRELOAD support which provides users
>> an easy way to test their code without having to integrate liblockdep into
>> said code. Simply doing:
>>
>>         lockdep my_app
>>
>> 	Would provide lockdep support to my_app.
>>
>> 	There is also a small test suite to test both mutexes and rwlocks, it's
>> 	based on the tests in lib/locking-selftest.c.
>>
>> 	This entire patch series was reviewed by lockdep maintainers and accepted to
>> 	the tip tree previously. It was pulled out so that the potential merge of
>> 	liblockdep won't delay the rest of the commits in the tip locking tree.
>>
>> 	For some more background about this entire thing, the folks at LWN did
>> 	an awesome overview: http://lwn.net/Articles/536363/
>>
>>
>> Changes from v1:
>>  - Addressed Peter's comments.
>>
> 
> root@twins:/usr/src/linux-2.6/tools/lib/lockdep# make
>   CC FPIC            common.o
> In file included from ./uinclude/linux/lockdep.h:13:0,
>                  from /usr/src/linux-2.6/tools/lib/lockdep/common.c:4:
> ./../../../include/linux/lockdep.h:21:27: fatal error: linux/linkage.h: No such file or directory
> compilation terminated.
> make: *** [common.o] Error 1

Oh, Ingo had a similar problem - you're using Quilt and that mishandles the
creation of empty files. You'll need to poke it stronger :)

I did notice a different issue due to a recent commit to kernel/lockdep.c, I'll
resend it again.


Thanks,
Sasha
