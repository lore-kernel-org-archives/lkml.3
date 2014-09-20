Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaITVBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 17:01:55 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:41354 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaITVBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 17:01:53 -0400
Message-ID: <541DEB33.2070508@roeck-us.net>
Date: Sat, 20 Sep 2014 14:01:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: linux-next: Tree for Sep 19
References: <20140919165817.225eb8b8@canb.auug.org.au> <20140919191514.GA5358@roeck-us.net> <541DD754.4040000@gmx.de>
In-Reply-To: <541DD754.4040000@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.541DEB41.0036,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 12:36 PM, Helge Deller wrote:
> Hi Günter,
>
> On 09/19/2014 09:15 PM, Guenter Roeck wrote:
>> On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
>>> Changes since 20140917:
>>>
>>> The fsl tree still had its build failure so I used the version from
>>> next-20140917.
>>>
>>> The v4l-dvb tree lost its build failure.
>>>
>>> The security tree gained a conflict against the file-locks tree.
>>>
>>> Non-merge commits (relative to Linus' tree): 6014
>>>   5488 files changed, 217522 insertions(+), 129375 deletions(-)
>>>
>>> ----------------------------------------------------------------------------
>>>
>>
>> parisc:defconfig, parisc:generic-32bit_defconfig:
>>
>> --------------
>> Error log:
>> arch/parisc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
>> arch/parisc/kernel/ptrace.c:274:2: error: implicit declaration of function
>> 'secure_computing' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[1]: *** [arch/parisc/kernel/ptrace.o] Error 1
>>
>> Bisect points to commit 273299fb6380 ('Merge branch 'x86/seccomp') which
>> obviously doesn't help much. Suspected culprit is c90f06943e05 ('parisc: Wire up
>> seccomp, getrandom and memfd_create syscalls') which seems to be missing an
>> include file.
>
> I could not reproduce this error with current git head.
>
With next-20140919 ?

> Nevertheless, it probably makes sense to #include <linux/seccomp.h> in ptrace.c to
> avoid a dependency on other header files to include it instead.
> I've added this patch to my for-next tree:
> http://git.kernel.org/cgit/linux/kernel/git/deller/parisc-linux.git/commit/?h=for-next&id=0f18557b017b3469e1f8edf5cf34c1cba856fdbe
>
> Could you try again?
>

That doesn't solve the problem for me, most likely because
HAVE_ARCH_SECCOMP_FILTER is not set for parisc in next-20140919.
This is what seccomp.h does with it:

#ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
static inline int secure_computing(void) { return 0; }
#else
static inline void secure_computing_strict(int this_syscall) { return; }
#endif

You don't have this flag in your tree. It was introduced in -next with
commit 'seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing'.

Guenter

