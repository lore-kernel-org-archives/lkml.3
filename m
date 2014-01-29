Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaA2Oh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:37:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:64674 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaA2Oeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:46 -0500
Message-ID: <52E91180.9080807@windriver.com>
Date: Wed, 29 Jan 2014 09:34:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 49/73] drivers/mtd: delete non-required instances of include
 <linux/init.h>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-50-git-send-email-paul.gortmaker@windriver.com> <20140129000216.GB8919@ld-irv-0074>
In-Reply-To: <20140129000216.GB8919@ld-irv-0074>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-28 07:02 PM, Brian Norris wrote:
> On Tue, Jan 21, 2014 at 04:22:52PM -0500, Paul Gortmaker wrote:
>> None of these files are actually using any __init type directives
>> and hence don't need to include <linux/init.h>.  Most are just a
>> left over from __devinit and __cpuinit removal, or simply due to
>> code getting copied from one driver to the next.
>>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Brian Norris <computersforpeace@gmail.com>
>> Cc: linux-mtd@lists.infradead.org
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
>> diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
>> index 8fc06bf..3428034e 100644
>> --- a/drivers/mtd/maps/sa1100-flash.c
>> +++ b/drivers/mtd/maps/sa1100-flash.c
>> @@ -7,7 +7,6 @@
>>  #include <linux/types.h>
>>  #include <linux/ioport.h>
>>  #include <linux/kernel.h>
>> -#include <linux/init.h>
>>  #include <linux/errno.h>
>>  #include <linux/slab.h>
>>  #include <linux/platform_device.h>
> 
> This file uses __exit_p(), from <linux/init.h>. So I dropped this hunk
> and pushed the rest to l2-mtd.git/next.

Thanks!  Not sure why that got caught up in the review, since I had __exit
in my regex filter. It had module.h so I never caught the false positive in
my build testing either.

Paul.
--
> 
> Thanks,
> Brian
> 
