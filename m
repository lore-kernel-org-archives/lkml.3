Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbbAGUAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:00:45 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:51351 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbAGUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:00:43 -0500
Message-ID: <54AD9062.8080204@de.ibm.com>
Date: Wed, 07 Jan 2015 21:00:34 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7
References: <20150107151618.7cb9d574@canb.auug.org.au> <20150107142656.GA5666@roeck-us.net> <20150107163310.GZ5280@linux.vnet.ibm.com> <20150107173022.GA26631@roeck-us.net> <20150107180922.GC5280@linux.vnet.ibm.com> <20150107191813.GA28881@roeck-us.net>
In-Reply-To: <20150107191813.GA28881@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010720-0025-0000-0000-00000343522E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.01.2015 um 20:18 schrieb Guenter Roeck:
> On Wed, Jan 07, 2015 at 10:09:22AM -0800, Paul E. McKenney wrote:
>> On Wed, Jan 07, 2015 at 09:30:22AM -0800, Guenter Roeck wrote:
>>> On Wed, Jan 07, 2015 at 08:33:10AM -0800, Paul E. McKenney wrote:
>>>> On Wed, Jan 07, 2015 at 06:26:56AM -0800, Guenter Roeck wrote:
>>>>> On Wed, Jan 07, 2015 at 03:16:18PM +1100, Stephen Rothwell wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> Changes since 20150106:
>>>>>>
>>>>>> *crickets*
>>>>>>
>>>>>> Non-merge commits (relative to Linus' tree): 1350
>>>>>>  1543 files changed, 41856 insertions(+), 24250 deletions(-)
>>>>>>
>>>>>> ----------------------------------------------------------------------------
>>>>>>
>>>>>
>>>>> New build failure for sh:dreamcast_defconfig:
>>>>>
>>>>> arch/sh/mm/gup.c: In function 'gup_get_pte':
>>>>> arch/sh/mm/gup.c:20:2: error: invalid initializer
>>>>> make[1]: *** [arch/sh/mm/gup.o] Error 1
>>>>>
>>>>> bisect log:
>>>>>
>>>>> # bad: [7e3619a6de57f0257a2f6480182d2287ee05e314] Add linux-next specific files for 20150107
>>>>> # good: [b1940cd21c0f4abdce101253e860feff547291b0] Linux 3.19-rc3
>>>>> git bisect start 'HEAD' 'v3.19-rc3'
>>>>> # good: [c48667c5659248ff2b2fbff5cd23c43b5768e81b] Merge remote-tracking branch 'net-next/master'
>>>>> git bisect good c48667c5659248ff2b2fbff5cd23c43b5768e81b
>>>>> # good: [b8cf629ce7d554711dd7ab256b00e6110355e1d7] Merge remote-tracking branch 'mmc-uh/next'
>>>>> git bisect good b8cf629ce7d554711dd7ab256b00e6110355e1d7
>>>>> # good: [cc52ff032bc2d91c78d7cf9aefcfa9e266ace816] Merge remote-tracking branch 'rcu/rcu/next'
>>>>> git bisect good cc52ff032bc2d91c78d7cf9aefcfa9e266ace816
>>>>> # bad: [9634277bcdab7b9d6a91409dc11d85502aa2e74b] Merge remote-tracking branch 'access_once/linux-next'
>>>>> git bisect bad 9634277bcdab7b9d6a91409dc11d85502aa2e74b
>>>>> # good: [261379560ee6aa65b4869c94eda0d3d60773aca3] Merge remote-tracking branch 'scsi/for-next'
>>>>> git bisect good 261379560ee6aa65b4869c94eda0d3d60773aca3
>>>>> # good: [38d45afa56bfca714780e45532760d64cd53b65b] Merge remote-tracking branch 'llvmlinux/for-next'
>>>>> git bisect good 38d45afa56bfca714780e45532760d64cd53b65b
>>>>> # good: [9afbe1ce2403c7d097bfaafcc5b27950040f7608] Merge remote-tracking branch 'y2038/y2038'
>>>>> git bisect good 9afbe1ce2403c7d097bfaafcc5b27950040f7608
>>>>> # bad: [a91ed664749cbec0325ef9da7d12619d9bb72e2d] kernel: tighten rules for ACCESS ONCE
>>>>> git bisect bad a91ed664749cbec0325ef9da7d12619d9bb72e2d
>>>>> # good: [e3865cc4a17e979e6b2f26af026686fae5567096] x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE
>>>>> git bisect good e3865cc4a17e979e6b2f26af026686fae5567096
>>>>> # good: [e2579c6f22ee0a43394d603cef6989dca98c5610] mm/gup: Replace ACCESS_ONCE with READ_ONCE
>>>>> git bisect good e2579c6f22ee0a43394d603cef6989dca98c5610
>>>>> # first bad commit: [a91ed664749cbec0325ef9da7d12619d9bb72e2d] kernel: tighten rules for ACCESS ONCE
>>>>>
>>>>> Maybe the ACCESS_ONCE in the affected file should be replaced with READ_ONCE ?
>>>>
>>>> That is my belief.  What happens when you try it?
>>>>
>>> Build passes, and my qemu tests pass as well. That doesn't mean
>>> that the change is correct, of course, since I don't know if the code
>>> in question is executed.
>>
>> Would it be possible to increment a counter at that location, then
>> print it out at some convenient point?
>>
> I made it simpler and just added a call to panic() ... which had no effect,
> so the function is not called in my qemu tests. Any idea what I would have
> to do to trigger a call ?
> 
>>> Should I send a patch with the change ?
>>
>> I believe such a patch is needed.  Testing would be good, but the patch
>> is what we were thinking of for this situation.
>>
> I'll probably send a patch marked "compile-tested only" if I can't find a way
> to test the change.

I was going to fix as well, but I can certainly take your patch. Can you send it with proper signed-off-by etc and I will add it to the access_once tree?

Christian

