Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaJIHUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:20:42 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59975 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaJIHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:20:35 -0400
Message-ID: <54363737.50700@gmail.com>
Date: Thu, 09 Oct 2014 09:20:23 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] staging: gs_fpgaboot: Fix "Possible unnecessary
 'out of memory' message" checkpatch.pl warning
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com> <54340568.7090700@gmail.com> <1412695842.2916.49.camel@joe-AO725> <54340C70.9070505@gmail.com> <54340CC8.8070903@gmail.com> <20141008224816.GA3583@kroah.com>
In-Reply-To: <20141008224816.GA3583@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 12:48 AM, Greg Kroah-Hartman wrote:
> On Tue, Oct 07, 2014 at 05:54:48PM +0200, Dzmitry Sledneu wrote:
>> Fix "Possible unnecessary 'out of memory' message" checkpatch.pl warning
>>
>> Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
>>
>> ---
>>  drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
>> index 9764a9a..0c18c4c 100644
>> --- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
>> +++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
>> @@ -295,10 +295,8 @@ static int gs_fpgaboot(void)
>>  	struct fpgaimage	*fimage;
>>  
>>  	fimage = kmalloc(sizeof(struct fpgaimage), GFP_KERNEL);
>> -	if (fimage == NULL) {
>> -		pr_err("No memory is available\n");
>> -		goto err_out;
>> -	}
>> +	if (!fimage)
>> +		return -ENOMEM;
>>  
>>  	err = gs_load_image(fimage, file);
>>  	if (err) {
>> @@ -340,7 +338,6 @@ err_out2:
>>  err_out1:
>>  	kfree(fimage);
>>  
>> -err_out:
>>  	return -1;
>>  
>>  }
> 
> Doesn't apply to my tree properly :(
> 

I looked at it in your tree and it has already been fixed there.

But the fix is not quite correct, because it returns -ENOPERM (-1)
it case kmalloc fails and not -ENOMEM (-12).

I will submit a new patch to fix this.

Dzmitry
