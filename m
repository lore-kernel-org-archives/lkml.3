Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3FXDGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:06:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:62814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3FXDGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,925,1363158000"; 
   d="scan'208";a="358428696"
Message-ID: <51C7B540.9020507@intel.com>
Date: Mon, 24 Jun 2013 10:56:00 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH] x86, tboot: provide debugfs interfaces to access TXT
 log
References: <1371974050-21436-1-git-send-email-qiaowei.ren@intel.com> <1371976573.3137.20.camel@joe-AO722>
In-Reply-To: <1371976573.3137.20.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 04:36 PM, Joe Perches wrote:
> On Sun, 2013-06-23 at 15:54 +0800, Qiaowei Ren wrote:
>> These logs come from tboot (Trusted Boot, an open source,
>> pre-kernel/VMM module that uses Intel TXT to perform a
>> measured and verified launch of an OS kernel/VMM.).
> []
>> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> []
>> +static struct tboot_log *get_log(void)
>> +{
>> +	struct tboot_log *log;
>> +
>> +	log = (struct tboot_log *)ioremap_nocache(TBOOT_SERIAL_LOG_ADDR,
>> +						  TBOOT_SERIAL_LOG_SIZE);
>
> You might want to fix the sparse errors.
>    CHECK   arch/x86/kernel/tboot.c
> arch/x86/kernel/tboot.c:362:16: warning: cast removes address space of expression
> arch/x86/kernel/tboot.c:368:25: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/tboot.c:368:25:    expected void volatile [noderef] <asn:2>*addr
> arch/x86/kernel/tboot.c:368:25:    got struct tboot_log *[assigned] log
> arch/x86/kernel/tboot.c:395:17: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/tboot.c:395:17:    expected void volatile [noderef] <asn:2>*addr
> arch/x86/kernel/tboot.c:395:17:    got struct tboot_log *[assigned] log
> arch/x86/kernel/tboot.c:479:16: warning: incorrect type in assignment (different address spaces)
> arch/x86/kernel/tboot.c:479:16:    expected void *config
> arch/x86/kernel/tboot.c:479:16:    got void [noderef] <asn:2>*
> arch/x86/kernel/tboot.c:485:19: warning: incorrect type in assignment (different address spaces)
> arch/x86/kernel/tboot.c:485:19:    expected void *heap_base
> arch/x86/kernel/tboot.c:485:19:    got void [noderef] <asn:2>*
> arch/x86/kernel/tboot.c:487:17: warning: incorrect type in argument 1 (different address spaces)
> arch/x86/kernel/tboot.c:487:17:    expected void volatile [noderef] <asn:2>*addr
> arch/x86/kernel/tboot.c:487:17:    got void *config
>
>
Well, I guess that I can use iomem related interface to fix these 
warnings caused by sparse.

Thanks,
Qiaowei
