Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaA0CHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 21:07:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:3465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbaA0CHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 21:07:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,726,1384329600"; 
   d="scan'208";a="444963875"
Message-ID: <52E5BDF1.20107@intel.com>
Date: Mon, 27 Jan 2014 10:01:21 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com> <20140126090808.GA30987@gmail.com> <9E0BE1322F2F2246BD820DA9FC397ADE014F22A8@SHSMSX102.ccr.corp.intel.com> <20140126151422.GA5386@gmail.com>
In-Reply-To: <20140126151422.GA5386@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 11:14 PM, Ingo Molnar wrote:
>
> * Ren, Qiaowei <qiaowei.ren@intel.com> wrote:
>
>> The size of one bound table is 4M bytes for 64bit, and 16K bytes for
>> 32bit. It can not be accessed by user-space, and it will be accessed
>> automatically by hardware.
>
> So, here's the bound-table allocation AFAICS:
>
> +static bool allocate_bt(unsigned long bd_entry)
> +{
> +       unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
> +       unsigned long bt_addr, old_val = 0;
> +
> +       bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
> +                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
>
> What ensures that user-space cannot access (and in particular, modify)
> the pages at bt_addr? It's a read-write anonymous mapping AFAICS.
>
Looks like that we can not be able to ensure this. I just mean that 
user-space doesn't know the bound tables, and it should not access them 
also.

Thanks,
Qiaowei
