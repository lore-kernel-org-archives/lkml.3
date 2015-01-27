Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbbA0W4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:56:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49769 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbA0W4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:56:05 -0500
Message-ID: <54C81755.4080502@oracle.com>
Date: Tue, 27 Jan 2015 17:55:17 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: James Dingwall <james@dingwall.me.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
References: <20150122055242.GA11089@dingwall.me.uk> <20150122082003.GA3441@pd.tnic> <54C10DB6.2050708@oracle.com> <54C10ED0.1010302@oracle.com> <20150122153002.GA3554@pd.tnic> <20150127221231.GE3351@pd.tnic>
In-Reply-To: <20150127221231.GE3351@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 05:12 PM, Borislav Petkov wrote:
> Hey Boris,
>
> On Thu, Jan 22, 2015 at 04:30:02PM +0100, Borislav Petkov wrote:
>> On Thu, Jan 22, 2015 at 09:53:04AM -0500, Boris Ostrovsky wrote:
>>> Alternatively, we could return an error (-EINVAL?) from
>>> microcode_init() when either of these two conditions is true.
>> Yeah, this should be the right fix.
>>
>> James, does that fix your issue? (It should.)
>>
>> ---
>> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
>> index 15c29096136b..36a83617eb21 100644
>> --- a/arch/x86/kernel/cpu/microcode/core.c
>> +++ b/arch/x86/kernel/cpu/microcode/core.c
>> @@ -552,7 +552,7 @@ static int __init microcode_init(void)
>>   	int error;
>>   
>>   	if (paravirt_enabled() || dis_ucode_ldr)
>> -		return 0;
>> +		return -EINVAL;
>>   
>>   	if (c->x86_vendor == X86_VENDOR_INTEL)
>>   		microcode_ops = init_intel_microcode();
> would you do the honor and write a proper patch? You found the bug so...
> :-D


Will do. This needs to go to stable as well, right?

-boris

