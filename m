Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3EJOLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:11:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3EJOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:11:41 -0400
Message-ID: <518CFFF5.2060807@oracle.com>
Date: Fri, 10 May 2013 10:11:01 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com> <1368115089-8909-3-git-send-email-sasha.levin@oracle.com> <20130510091816.GC3039@dyad.programming.kicks-ass.net> <20130510101131.GA31152@dyad.programming.kicks-ass.net> <518CF4D5.4070000@oracle.com> <20130510140328.GC304@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510140328.GC304@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 10:03 AM, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 09:23:33AM -0400, Sasha Levin wrote:
>> Wait, I'm confused. Over here, patch is fine with creating empty files:
>>
>> lappy lockdep # touch test.c
>> lappy lockdep # git diff /dev/null test.c > test.patch
>> lappy lockdep # rm test.c
>> lappy lockdep # file test.c
>> test.c: ERROR: cannot open `test.c' (No such file or directory)
>> lappy lockdep # patch -i test.patch
>> patching file test.c
>> lappy lockdep # file test.c
>> test.c: empty
>> lappy lockdep # cat test.patch
>> diff --git a/tools/lib/lockdep/test.c b/tools/lib/lockdep/test.c
>> new file mode 100644
>> index 0000000..e69de29
>> lappy lockdep #
>>
>> So it seems that here patch would cleanly create empty files, what does quilt
>> do differently?
> 
> 
> root@twins:~/tmp# touch ponies
> root@twins:~/tmp# git diff /dev/null ponies
> diff --git a/ponies b/ponies
> new file mode 100644
> index 0000000..e69de29
> root@twins:~/tmp# git diff /dev/null ponies > ponies.patch
> root@twins:~/tmp# rm ponies
> root@twins:~/tmp# patch < ponies.patch
> patch: **** Only garbage was found in the patch input.
> 
> t@twins:~/tmp# patch --version
> patch 2.6.1
> Copyright (C) 1988 Larry Wall
> Copyright (C) 2003, 2009 Free Software Foundation, Inc.
> 
> This program comes with NO WARRANTY, to the extent permitted by law.
> You may redistribute copies of this program
> under the terms of the GNU General Public License.
> For more information about these matters, see the file named COPYING.
> 
> written by Larry Wall and Paul Eggert
> 

Ah!

# patch --version
GNU patch 2.7.1

I've tried downgrading to 2.6.1, and now I get:

lappy lockdep # patch < test.patch
patch: **** Only garbage was found in the patch input.


Thanks,
Sasha
