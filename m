Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966788Ab3DQPvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:51:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:15778 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966025Ab3DQPvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:51:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,494,1363158000"; 
   d="scan'208";a="319767439"
Message-ID: <516EC508.6070200@linux.intel.com>
Date: Wed, 17 Apr 2013 08:51:36 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
References: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn> <516EAF31.8000107@linux.intel.com> <516EBF23.2090600@sr71.net>
In-Reply-To: <516EBF23.2090600@sr71.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/17/2013 08:26 AM, Dave Hansen wrote:
> On 04/17/2013 07:18 AM, Darren Hart wrote:
>>>> This also needs a comment in futex.h describing the usage of the offset
>>>> field in union futex_key as well as above get_futex_key describing the
>>>> key for shared mappings.
>>>>
>>> As far as I know , the max size of one hugepage is 1 GBytes for x86 cpu.
>>> Can some other cpus support greater hugepage even more than 4 GBytes? If 
>>> so, we can change the type of 'offset' from int to long to avoid 
>>> truncating.
>>
>> I discussed this with Dave Hansen, on CC, and he thought we needed 9
>> bits, so even on x86 32b we should be covered.
> 
> I think the problem is actually on 64-bit since you still only have
> 32-bits in an 'int' there.
> 
> I guess it's remotely possible that we could have some
> mega-super-huge-gigantic pages show up in hardware some day, or that
> somebody would come up with software-only one.  I bet there's a lot more
> code that will break in the kernel than this futex code, though.
> 
> The other option would be to start #defining some build-time constant
> for what the largest possible huge page size is, then BUILD_BUG_ON() it.
> 
> Or you can just make it a long ;)

If we make it a long I'd want to see futextest performance tests before
and after. Messing with the futex_key has been known to have bad results
in the past :-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
