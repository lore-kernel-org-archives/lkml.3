Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3DXIcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:32:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41132 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3DXIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:32:29 -0400
X-Spam-Score: -100.8
Message-ID: <5177986E.9020105@asianux.com>
Date: Wed, 24 Apr 2013 16:31:42 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/powerpc/kernel: using %12.12s instead of %12s for
 avoiding memory overflow.
References: <5100B53C.3030109@asianux.com> <512055D0.7050100@asianux.com> <514FD2E0.5030805@asianux.com> <51778D97.4080409@asianux.com> <51779491.10307@linux.vnet.ibm.com> <51779588.1070203@linux.vnet.ibm.com>
In-Reply-To: <51779588.1070203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月24日 16:19, Vasant Hegde wrote:
>>>>>>     for tmp_part->header.name:
>>>>>> >>>>>       it is "Terminating null required only for names<   12 chars".
>>>>>> >>>>>       so need to limit the %.12s for it in printk
>>>>>> >>>>>
>>>>>> >>>>>     additional info:
>>>>>> >>>>>
>>>>>> >>>>>       %12s  limit the width, not for the original string output length
>>>>>> >>>>>             if name length is more than 12, it still can be fully displayed.
>>>>>> >>>>>             if name length is less than 12, the ' ' will be filled before name.
>>>>>> >>>>>
>>>>>> >>>>>       %.12s truly limit the original string output length (precision)
>>>>>> >>>>>
>>>>>> >>>>>
>>>>>> >>>>> Signed-off-by: Chen Gang<gang.chen@asianux.com>
>>>>>> >>>>> ---
>>>>>> >>>>>    arch/powerpc/kernel/nvram_64.c |    2 +-
>>>>>> >>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>> >>>>>
>>>>>> >>>>> diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
>>>>>> >>>>> index bec1e93..57bf6d2 100644
>>>>>> >>>>> --- a/arch/powerpc/kernel/nvram_64.c
>>>>>> >>>>> +++ b/arch/powerpc/kernel/nvram_64.c
>>>>>> >>>>> @@ -202,7 +202,7 @@ static void __init nvram_print_partitions(char * label)
>>>>>> >>>>>    	printk(KERN_WARNING "--------%s---------\n", label);
>>>>>> >>>>>    	printk(KERN_WARNING "indx\t\tsig\tchks\tlen\tname\n");
>>>>>> >>>>>    	list_for_each_entry(tmp_part,&nvram_partitions, partition) {
>>>>>> >>>>> -		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12s\n",
>>>>>> >>>>> +		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12.12s\n",
>> > 
>> > First, this code in inside NVRAM_DEBUG which is used only for debug purpose and
>> > AFAIK, all partition names are less than 20 character. So I don't think we need
> Sorry.. I meant 12 character.

Please see line 283:
  "strncpy(part->header.name, "wwwwwwwwwwww", 12);"
  (it is not a NUL terminated string, and the length is 12)

And also, can we be sure that all partition names should be less than 12
characters ?

All together, I think we still need %12.12s to protect the memory.

Thanks.

-- 
Chen Gang

Asianux Corporation
