Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaAXG5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:57:10 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:60214 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaAXG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <52E20A56.1000507@ti.com>
References: <52E19C7D.7050603@intel.com>
	<CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com>
	<52E20A56.1000507@ti.com>
Date: Thu, 23 Jan 2014 22:57:08 -0800
X-Google-Sender-Auth: YsDw9KTCdVHNulJUivKm_kmzRlk
Message-ID: <CAE9FiQV+QETh62-RExJx_hmS0mUzEuUQkO7M-eKX6KAfj5Geog@mail.gmail.com>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
From: Yinghai Lu <yinghai@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:38 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Yinghai,
>
> On Friday 24 January 2014 12:55 AM, Yinghai Lu wrote:
>> On Thu, Jan 23, 2014 at 2:49 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>> > Linus's current tree doesn't boot on an 8-node/1TB NUMA system that I
>>> > have.  Its reboots are *LONG*, so I haven't fully bisected it, but it's
>>> > down to a just a few commits, most of which are changes to the memblock
>>> > code.  Since the panic is in the memblock code, it looks like a
>>> > no-brainer.  It's almost certainly the code from Santosh or Grygorii
>>> > that's triggering this.
>>> >
>>> > Config and good/bad dmesg with memblock=debug are here:
>>> >
>>> >         http://sr71.net/~dave/intel/3.13/
>>> >
>>> > Please let me know if you need it bisected further than this.
>> Please check attached patch, and it should fix the problem.
>>
>
> [...]
>
>>
>> Subject: [PATCH] x86: Fix numa with reverting wrong memblock setting.
>>
>> Dave reported Numa on x86 is broken on system with 1T memory.
>>
>> It turns out
>> | commit 5b6e529521d35e1bcaa0fe43456d1bbb335cae5d
>> | Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> | Date:   Tue Jan 21 15:50:03 2014 -0800
>> |
>> |    x86: memblock: set current limit to max low memory address
>>
>> set limit to low wrongly.
>>
>> max_low_pfn_mapped is different from max_pfn_mapped.
>> max_low_pfn_mapped is always under 4G.
>>
>> That will memblock_alloc_nid all go under 4G.
>>
>> Revert that offending patch.
>>
>> Reported-by: Dave Hansen <dave.hansen@intel.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>>
> This mostly will fix the $subject issue but the regression
> reported by Andrew [1] will surface with the revert. Its clear
> now that even though commit fixed the issue, it wasn't the fix.
>
> Would be great if you can have a look at the thread.

>> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/03770.html

Andrew,

Did you bisect which patch in that 23 patchset cause your system have problem?

Thanks

Yinghai
