Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaAZI3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 03:29:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:30901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbaAZI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 03:29:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,723,1384329600"; 
   d="scan'208";a="444712296"
Message-ID: <52E4C5F2.8070707@intel.com>
Date: Sun, 26 Jan 2014 16:23:14 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com> <20140126082201.GB28831@gmail.com>
In-Reply-To: <20140126082201.GB28831@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 04:22 PM, Ingo Molnar wrote:
>
> * Qiaowei Ren <qiaowei.ren@intel.com> wrote:
>
>> This patch adds the PR_MPX_INIT and PR_MPX_RELEASE prctl()
>> commands on the x86 platform. These commands can be used to
>> init and release MPX related resource.
>>
>> A MMU notifier will be registered during PR_MPX_INIT
>> command execution. So the bound tables can be automatically
>> deallocated when one memory area is unmapped.
>>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>   arch/x86/Kconfig                 |    4 ++
>>   arch/x86/include/asm/mpx.h       |    9 ++++
>>   arch/x86/include/asm/processor.h |   16 +++++++
>>   arch/x86/kernel/mpx.c            |   84 ++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/prctl.h       |    6 +++
>>   kernel/sys.c                     |   12 +++++
>>   6 files changed, 131 insertions(+), 0 deletions(-)
>
> Hm. What is the expected typical frequency of these syscalls for a
> larger application like a web browser? Only once per startup
> typically, or will they be called more frequently?
>

It will be only once per startup.

Thanks,
Qiaowei
