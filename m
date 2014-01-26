Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaAZEpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 23:45:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:36480 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbaAZEpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 23:45:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,721,1384329600"; 
   d="scan'208";a="444669336"
Message-ID: <52E4919B.8050408@intel.com>
Date: Sun, 26 Jan 2014 12:39:55 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 12:22 PM, David Rientjes wrote:
> On Sun, 26 Jan 2014, Qiaowei Ren wrote:
>
>> This patch adds new fields about bound violation into siginfo
>> structure. si_lower and si_upper are respectively lower bound
>> and upper bound when bound violation is caused.
>>
>> These fields will be set in #BR exception handler by decoding
>> the user instruction and constructing the faulting pointer.
>> A userspace application can get violation address, lower bound
>> and upper bound for bound violation from this new siginfo structure.
>>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>
> Same 32-bit warnings I reported for v2:
>
> arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
> arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>
> and the documentation says you explicitly want to support this config.
>
> These types of warnings are usually indicative of real problems when
> you're storing upper and lower bits in 32-bit fields after casting them
> from 64-bit values.
>
> I'm also not sure if the added fields to the generic struct siginfo can be
> justified for this.
>
According to MPX spec, for 32-bit case, the upper 32-bits of 64-bits 
bound register are ignored, and so casting to pointer from 64-bit values 
should be not produce any problems.

Thanks,
Qiaowei
