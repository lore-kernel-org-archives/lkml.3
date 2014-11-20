Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaKTN5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:57:46 -0500
Received: from bes.se.axis.com ([195.60.68.10]:48268 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbaKTN5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:57:45 -0500
Message-ID: <546DF354.6030803@axis.com>
Date: Thu, 20 Nov 2014 14:57:40 +0100
From: Niklas Svensson <niklas.svensson@axis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Paul Burton <paul.burton@imgtec.com>
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: mips-cm: CM regions are disabled at boot
References: <1416486540-28681-1-git-send-email-niklass@axis.com> <20141120123434.GW1127@pburton-laptop>
In-Reply-To: <20141120123434.GW1127@pburton-laptop>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 01:34 PM, Paul Burton wrote:
> On Thu, Nov 20, 2014 at 01:29:00PM +0100, Niklas Svensson wrote:
>> Each CM_REGION_TARGET is set to disabled at boot,
> 
> That part is true...
> 
>> so there is no need to disable the matching
>> CM_GCR_REG explicitly.
> 
> ...however there is no guarantee that the bootloader, or another kernel,
> or some other piece of code didn't program the registers differently
> before Linux starts. So I believe this patch to be incorrect.


That is the reason for this patch. This will overwrite settings written by the bootloader.

Say if the bootloader sets up an iocu, then these writes will clear those settings.

> 
> Thanks,
>     Paul
> 
>>
>> Signed-off-by: Niklas Svensson <niklass@axis.com>
>> ---
>>  arch/mips/kernel/mips-cm.c | 10 ----------
>>  1 file changed, 10 deletions(-)
>>
>> diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
>> index f76f7a0..a4bbfd9 100644
>> --- a/arch/mips/kernel/mips-cm.c
>> +++ b/arch/mips/kernel/mips-cm.c
>> @@ -104,16 +104,6 @@ int mips_cm_probe(void)
>>  	base_reg |= CM_GCR_BASE_CMDEFTGT_MEM;
>>  	write_gcr_base(base_reg);
>>  
>> -	/* disable CM regions */
>> -	write_gcr_reg0_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
>> -	write_gcr_reg0_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
>> -	write_gcr_reg1_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
>> -	write_gcr_reg1_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
>> -	write_gcr_reg2_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
>> -	write_gcr_reg2_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
>> -	write_gcr_reg3_base(CM_GCR_REGn_BASE_BASEADDR_MSK);
>> -	write_gcr_reg3_mask(CM_GCR_REGn_MASK_ADDRMASK_MSK);
>> -
>>  	/* probe for an L2-only sync region */
>>  	mips_cm_probe_l2sync();
>>  
>> -- 
>> 2.1.3
>>

