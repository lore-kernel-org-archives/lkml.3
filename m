Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3E1Sae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:30:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61771 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3E1Sad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:30:33 -0400
Message-ID: <51A4F7D5.9070107@gmail.com>
Date: Tue, 28 May 2013 20:30:45 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, ming.lei@canonical.com
Subject: Re: [PATCH] firmware: move EXPORT_SYMBOL annotations
References: <1369340238-8631-1-git-send-email-zonque@gmail.com> <s5h38t8stua.wl%tiwai@suse.de>
In-Reply-To: <s5h38t8stua.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2013 10:35, Takashi Iwai wrote:
> At Thu, 23 May 2013 22:17:18 +0200,
> Daniel Mack wrote:
>>
>> Move EXPORT_SYMBOL annotations so they follow immediately after the
>> closing function brace line.
>>
>> Signed-off-by: Daniel Mack <zonque@gmail.com>
> 
>   Acked-by: Takashi Iwai <tiwai@suse.de>

Thanks. Greg, could you take this through your tree?


Daniel


> 
> 
> thanks,
> 
> Takashi
> 
>> ---
>>  drivers/base/firmware_class.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 4b1f926..4d9643f 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -1079,6 +1079,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>>  {
>>  	return _request_firmware(firmware_p, name, device, true, false);
>>  }
>> +EXPORT_SYMBOL(request_firmware);
>>  
>>  /**
>>   * release_firmware: - release the resource associated with a firmware image
>> @@ -1092,6 +1093,7 @@ void release_firmware(const struct firmware *fw)
>>  		kfree(fw);
>>  	}
>>  }
>> +EXPORT_SYMBOL(release_firmware);
>>  
>>  /* Async support */
>>  struct firmware_work {
>> @@ -1172,6 +1174,7 @@ request_firmware_nowait(
>>  	schedule_work(&fw_work->work);
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL(request_firmware_nowait);
>>  
>>  /**
>>   * cache_firmware - cache one firmware image in kernel memory space
>> @@ -1202,6 +1205,7 @@ int cache_firmware(const char *fw_name)
>>  
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(cache_firmware);
>>  
>>  /**
>>   * uncache_firmware - remove one cached firmware image
>> @@ -1232,6 +1236,7 @@ int uncache_firmware(const char *fw_name)
>>  
>>  	return -EINVAL;
>>  }
>> +EXPORT_SYMBOL_GPL(uncache_firmware);
>>  
>>  #ifdef CONFIG_PM_SLEEP
>>  static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
>> @@ -1536,9 +1541,3 @@ static void __exit firmware_class_exit(void)
>>  
>>  fs_initcall(firmware_class_init);
>>  module_exit(firmware_class_exit);
>> -
>> -EXPORT_SYMBOL(release_firmware);
>> -EXPORT_SYMBOL(request_firmware);
>> -EXPORT_SYMBOL(request_firmware_nowait);
>> -EXPORT_SYMBOL_GPL(cache_firmware);
>> -EXPORT_SYMBOL_GPL(uncache_firmware);
>> -- 
>> 1.8.1.4
>>

