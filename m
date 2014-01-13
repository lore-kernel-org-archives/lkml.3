Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaAMDW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:22:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:24878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaAMDW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,650,1384329600"; 
   d="scan'208";a="464080010"
Message-ID: <52D35ABB.8070904@intel.com>
Date: Mon, 13 Jan 2014 11:17:15 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com> <20140112092019.GA3664@pd.tnic>
In-Reply-To: <20140112092019.GA3664@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 05:20 PM, Borislav Petkov wrote:
> On Sun, Jan 12, 2014 at 05:20:00PM +0800, Qiaowei Ren wrote:
>> +static bool allocate_bt(unsigned long bd_entry)
>> +{
>> +	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
>> +	unsigned long bt_addr, old_val;
>> +
>> +	bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
>> +			MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
>
> Are we sure about this? We can do a possible memory allocation in
> mmap_region() in this exception handler context. And yes, we do a
> conditional_sti(), which makes it all the more susceptible.
>
> Have you run this with lockdep enabled?
>
Yes, I run this with lockdep enabled.

Thanks,
Qiaowei
