Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966643Ab3DQOSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:18:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:49716 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966409Ab3DQOSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:18:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,492,1363158000"; 
   d="scan'208";a="287444595"
Message-ID: <516EAF31.8000107@linux.intel.com>
Date: Wed, 17 Apr 2013 07:18:25 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: zhang.yi20@zte.com.cn
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
References: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn>
In-Reply-To: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/17/2013 02:55 AM, zhang.yi20@zte.com.cn wrote:
> Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/17 01:57:10:
> 
>> Again, a functional testcase in futextest would be a good idea. This
>> helps validate the patch and also can be used to identify regressions in
>> the future.
> 
> I will post the testcase code later.
> 
>>
>> What is the max value of comp_idx? Are we at risk of truncating it?
>> Looks like not really from my initial look.
>>
>> This also needs a comment in futex.h describing the usage of the offset
>> field in union futex_key as well as above get_futex_key describing the
>> key for shared mappings.
>>
>>
> 
> As far as I know , the max size of one hugepage is 1 GBytes for x86 cpu.
> Can some other cpus support greater hugepage even more than 4 GBytes? If 
> so, we can change the type of 'offset' from int to long to avoid 
> truncating.

I discussed this with Dave Hansen, on CC, and he thought we needed 9
bits, so even on x86 32b we should be covered.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
