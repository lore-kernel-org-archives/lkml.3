Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3IXNwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:52:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48416 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354Ab3IXNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:52:16 -0400
Message-ID: <524198FD.2090104@sgi.com>
Date: Tue, 24 Sep 2013 06:51:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] x86/UV/KDB/NMI: Updates for NMI/KDB handler for SGI
 UV
References: <20130923212459.544517569@asylum.americas.sgi.com> <20130924075212.GG28538@gmail.com>
In-Reply-To: <20130924075212.GG28538@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/24/2013 12:52 AM, Ingo Molnar wrote:
> 
> Hm, do you test-build your patches? 

Both build and test incessantly...

This series produces the following
> annoying warning:
> 
>  arch/x86/platform/uv/uv_nmi.c: In function ‘uv_nmi_setup’:
>  arch/x86/platform/uv/uv_nmi.c:664:2: warning: the address of ‘uv_nmi_cpu_mask’ will always evaluate as ‘true’ [-Waddress]

I didn't hit the above warning since I never tried building without
CONFIG_CPUMASK_OFFSTACK defined.  I wonder if uv_nmi.c should not
be built if not on an enterprise sized system?

> 
> This:
> 
>         alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL);
>         BUG_ON(!uv_nmi_cpu_mask);
> 
> 
> the way to check for allocation failures is by checking the return value 
> of alloc_cpumask_var():
> 
> 	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
> 
> I've fixed this in the patch.

Thanks!!  I should have remembered this since it was my code. (doh!)
> 
> Thanks,
> 
> 	Ingo
> 
