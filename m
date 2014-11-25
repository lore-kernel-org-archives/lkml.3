Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931AbaKYSkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:40:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:40:43 -0500
Message-ID: <5474CDCE.6040000@oracle.com>
Date: Tue, 25 Nov 2014 13:43:26 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205150.700188369@linuxfoundation.org> <20141119205153.916605840@linuxfoundation.org> <5474C67A.7040200@oracle.com> <20141125182410.GB4128@pd.tnic>
In-Reply-To: <20141125182410.GB4128@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:24 PM, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 01:12:10PM -0500, Boris Ostrovsky wrote:
>> On 11/19/2014 03:52 PM, Greg Kroah-Hartman wrote:
>>> 3.17-stable review patch.  If anyone has any objections, please let me know.
>>
>> This breaks PV on Xen.
>>
>> -boris
>>
>>> ------------------
>>>
>>> From: Borislav Petkov <bp@suse.de>
>>>
>>> commit 85be07c32496dc264661308e4d9d4e9ccaff8072 upstream.
>>>
>>> We should be accessing it through a pointer, like on the BSP.
>>>
>>> Tested-by: Richard Hendershot <rshendershot@mchsi.com>
>>> Fixes: 65cef1311d5d ("x86, microcode: Add a disable chicken bit")
>>> Signed-off-by: Borislav Petkov <bp@suse.de>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> ---
>>>   arch/x86/kernel/cpu/microcode/core_early.c |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- a/arch/x86/kernel/cpu/microcode/core_early.c
>>> +++ b/arch/x86/kernel/cpu/microcode/core_early.c
>>> @@ -124,7 +124,7 @@ void __init load_ucode_bsp(void)
>>>   static bool check_loader_disabled_ap(void)
>>>   {
>>>   #ifdef CONFIG_X86_32
>>> -	return __pa_nodebug(dis_ucode_ldr);
>>> +	return *((bool *)__pa_nodebug(&dis_ucode_ldr));
> And practically the same line in check_loader_disabled_bsp() doesn't?


I don't think this routine is called on PV.


-boris



