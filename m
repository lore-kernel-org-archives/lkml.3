Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3CYEa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:30:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32208 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CYEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:30:56 -0400
X-Spam-Score: -100.8
Message-ID: <514FD2E0.5030805@asianux.com>
Date: Mon, 25 Mar 2013 12:30:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: benh@kernel.crashing.org, paulus@samba.org,
        Michael Neuling <mikey@neuling.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
CC: linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/powerpc/kernel: using %12.12s instead of %12s for
 avoiding memory overflow.
References: <5100B53C.3030109@asianux.com> <512055D0.7050100@asianux.com>
In-Reply-To: <512055D0.7050100@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  could you help check this patch whether is ok ?

  thanks.


On 2013年02月17日 12:00, Chen Gang wrote:
> Hello relative members:
> 
>   please give a glance to this patch, when you have time.
> 
>   thanks.
> 
>   :-)
> 
> gchen.
> 
> 
> 于 2013年01月24日 12:14, Chen Gang 写道:
>>
>>   for tmp_part->header.name:
>>     it is "Terminating null required only for names < 12 chars".
>>     so need to limit the %.12s for it in printk
>>
>>   additional info:
>>
>>     %12s  limit the width, not for the original string output length
>>           if name length is more than 12, it still can be fully displayed.
>>           if name length is less than 12, the ' ' will be filled before name.
>>
>>     %.12s truly limit the original string output length (precision)
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/powerpc/kernel/nvram_64.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
>> index bec1e93..57bf6d2 100644
>> --- a/arch/powerpc/kernel/nvram_64.c
>> +++ b/arch/powerpc/kernel/nvram_64.c
>> @@ -202,7 +202,7 @@ static void __init nvram_print_partitions(char * label)
>>  	printk(KERN_WARNING "--------%s---------\n", label);
>>  	printk(KERN_WARNING "indx\t\tsig\tchks\tlen\tname\n");
>>  	list_for_each_entry(tmp_part, &nvram_partitions, partition) {
>> -		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12s\n",
>> +		printk(KERN_WARNING "%4d    \t%02x\t%02x\t%d\t%12.12s\n",
>>  		       tmp_part->index, tmp_part->header.signature,
>>  		       tmp_part->header.checksum, tmp_part->header.length,
>>  		       tmp_part->header.name);
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
