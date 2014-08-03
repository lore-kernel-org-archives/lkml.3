Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaHCBSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 21:18:13 -0400
Received: from s87.loopia.se ([194.9.94.112]:31215 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaHCBSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 21:18:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53DD8E17.1@hanshq.net>
Date: Sat, 02 Aug 2014 18:19:19 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
        linux-cifs@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] cris: fix %d confusingly prefixed with 0x in format
 string
References: <1407018043-648-1-git-send-email-hans@hanshq.net> <1407026806.1835.21.camel@joe-AO725>
In-Reply-To: <1407026806.1835.21.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/02/2014 05:46 PM, Joe Perches wrote:
> On Sat, 2014-08-02 at 15:20 -0700, Hans Wennborg wrote:
>> Signed-off-by: Hans Wennborg <hans@hanshq.net>
>> ---
>>   arch/cris/arch-v32/drivers/cryptocop.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
> []
>> @@ -3155,7 +3155,7 @@ static void print_dma_descriptors(struct cryptocop_int_operation *iop)
>>   	printk("print_dma_descriptors start\n");
>>
>>   	printk("iop:\n");
>> -	printk("\tsid: 0x%lld\n", iop->sid);
>> +	printk("\tsid: 0x%llx\n", iop->sid);
>>
>>   	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
>>   	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);
>
> Thanks.
>
> This is a surprisingly common error:
>
> $ /usr/bin/git grep -P '0x\%(?!ull\b|ul\b|u\b|lu\b|llu\b|llux\b|lux\b|lx\b|lluX\b|luX\b|lX\b)[ul]*[ud]'
[...]

Yes, I have a patch for a bunch of these, but I figured it would be 
easier to get it merged if I split it up. (Complete kernel newbie here.)

  - Hans
