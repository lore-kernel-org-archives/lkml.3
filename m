Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3DXIPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:15:39 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35751 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3DXIPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:15:36 -0400
Message-ID: <51779491.10307@linux.vnet.ibm.com>
Date: Wed, 24 Apr 2013 13:45:13 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Michael Neuling <mikey@neuling.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] arch/powerpc/kernel: using %12.12s instead of %12s for
 avoiding memory overflow.
References: <5100B53C.3030109@asianux.com> <512055D0.7050100@asianux.com> <514FD2E0.5030805@asianux.com> <51778D97.4080409@asianux.com>
In-Reply-To: <51778D97.4080409@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042408-5816-0000-0000-000007AF78F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 01:15 PM, Chen Gang wrote:
> Hello Vasant Hegde:
> 
> How about this patch, is it OK ?
> 
> Thanks.
> 
> 
> On 2013年03月25日 12:30, Chen Gang wrote:
>> Hello Maintainers:
>>
>>    could you help check this patch whether is ok ?
>>
>>    thanks.
>>
>>
>> On 2013年02月17日 12:00, Chen Gang wrote:
>>> Hello relative members:
>>>
>>>    please give a glance to this patch, when you have time.
>>>
>>>    thanks.
>>>
>>>    :-)
>>>
>>> gchen.
>>>
>>>
>>> 于 2013年01月24日 12:14, Chen Gang 写道:
>>>>
>>>>    for tmp_part->header.name:
>>>>      it is "Terminating null required only for names<  12 chars".
>>>>      so need to limit the %.12s for it in printk
>>>>
>>>>    additional info:
>>>>
>>>>      %12s  limit the width, not for the original string output length
>>>>            if name length is more than 12, it still can be fully displayed.
>>>>            if name length is less than 12, the ' ' will be filled before name.
>>>>
>>>>      %.12s truly limit the original string output length (precision)
>>>>
>>>>
>>>> Signed-off-by: Chen Gang<gang.chen@asianux.com>
>>>> ---
>>>>   arch/powerpc/kernel/nvram_64.c |    2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
>>>> index bec1e93..57bf6d2 100644
>>>> --- a/arch/powerpc/kernel/nvram_64.c
>>>> +++ b/arch/powerpc/kernel/nvram_64.c
>>>> @@ -202,7 +202,7 @@ static void __init nvram_print_partitions(char * label)
>>>>   	printk(KERN_WARNING "--------%s---------\n", label);
>>>>   	printk(KERN_WARNING "indx\t\tsig\tchks\tlen\tname\n");
>>>>   	list_for_each_entry(tmp_part,&nvram_partitions, partition) {
>>>> -		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12s\n",
>>>> +		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12.12s\n",

First, this code in inside NVRAM_DEBUG which is used only for debug purpose and
AFAIK, all partition names are less than 20 character. So I don't think we need
this patch.

-Vasant

>>>>   		       tmp_part->index, tmp_part->header.signature,
>>>>   		       tmp_part->header.checksum, tmp_part->header.length,
>>>>   		       tmp_part->header.name);
>>>>
>>>
>>>
>>
>>
> 
> 

