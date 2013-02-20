Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936008Ab3BTUTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:19:31 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:64441 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934802Ab3BTUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:19:28 -0500
Message-ID: <5125303C.3080507@metafoo.de>
Date: Wed, 20 Feb 2013 21:21:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 05/16] blackfin idle: delete pm_idle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <1656351.lki82jZfSs@vostro.rjw.lan> <512529C2.4050909@metafoo.de> <1759773.UdmLmFNAfS@vostro.rjw.lan>
In-Reply-To: <1759773.UdmLmFNAfS@vostro.rjw.lan>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 08:59 PM, Rafael J. Wysocki wrote:
> On Wednesday, February 20, 2013 08:53:38 PM Lars-Peter Clausen wrote:
>> On 02/20/2013 08:52 PM, Rafael J. Wysocki wrote:
>>> On Monday, February 18, 2013 05:28:19 PM Lars-Peter Clausen wrote:
>>>> On 02/10/2013 06:58 AM, Len Brown wrote:
>>>>> From: Len Brown <len.brown@intel.com>
>>>>>
>>>>> pm_idle is dead code on blackfin.
>>>>>
>>>>> Signed-off-by: Len Brown <len.brown@intel.com>
>>>>> Cc: uclinux-dist-devel@blackfin.uclinux.org
>>>>> ---
>>>>>  arch/blackfin/kernel/process.c | 7 -------
>>>>>  1 file changed, 7 deletions(-)
>>>>>
>>>>> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
>>>>> index 3e16ad9..8061426 100644
>>>>> --- a/arch/blackfin/kernel/process.c
>>>>> +++ b/arch/blackfin/kernel/process.c
>>>>> @@ -39,12 +39,6 @@ int nr_l1stack_tasks;
>>>>>  void *l1_stack_base;
>>>>>  unsigned long l1_stack_len;
>>>>>  
>>>>> -/*
>>>>> - * Powermanagement idle function, if any..
>>>>> - */
>>>>> -void (*pm_idle)(void) = NULL;
>>>>> -EXPORT_SYMBOL(pm_idle);
>>>>> -
>>>>>  void (*pm_power_off)(void) = NULL;
>>>>>  EXPORT_SYMBOL(pm_power_off);
>>>>>  
>>>>> @@ -81,7 +75,6 @@ void cpu_idle(void)
>>>>>  {
>>>>>  	/* endless idle loop with no priority at all */
>>>>>  	while (1) {
>>>>> -		void (*idle)(void) = pm_idle;
>>>>
>>>> Hi,
>>>>
>>>> This results in the following error:
>>>>
>>>> arch/blackfin/kernel/process.c: In function ‘cpu_idle’:
>>>> arch/blackfin/kernel/process.c:83: error: ‘idle’ undeclared (first use in
>>>> this function)
>>>> arch/blackfin/kernel/process.c:83: error: (Each undeclared identifier is
>>>> reported only once
>>>> arch/blackfin/kernel/process.c:83: error: for each function it appears in.)
>>>> arch/blackfin/kernel/process.c:88: error: implicit declaration of function
>>>> ‘idle’
>>>>
>>>>
>>>> This change on top of your patch, fixes it.
>>>
>>> Lars, I need your sign-off for the patch below.  May I add it?
>>>
>>> Rafael
>>
>> Sure, I didn't realize the patches had already been merged, otherwise I'd have
>> sent a proper patch.
> 
> Please do now, if you can.  Sorry for the trouble.
> 

I can send it tomorrow morning, it's on my machine at work.

- Lars

