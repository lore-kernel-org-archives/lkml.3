Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3HUCZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:25:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13907 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3HUCZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:25:16 -0400
X-Spam-Score: -101.0
Message-ID: <52142008.203@asianux.com>
Date: Wed, 21 Aug 2013 10:03:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: use scnprintf() instead of sprintf()
References: <5212DEC3.9070007@asianux.com> <87vc30gao5.fsf@rustcorp.com.au>
In-Reply-To: <87vc30gao5.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 02:04 PM, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
>> For some strings, they are permitted to be larger than PAGE_SIZE, so
>> need use scnprintf() instead of sprintf(), or it will cause issue.
>>
>> One case is:
>>
>>   if a module version is crazy defined (length more than PAGE_SIZE),
>>   'modinfo' command is still OK (print full contents),
>>   but for "cat /sys/modules/'modname'/version", will cause issue in kernel.
> 
> Applied!
> 

Thanks.

> Thanks,
> Rusty.
> 
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/module.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 2069158..0618e63 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -603,7 +603,7 @@ static void setup_modinfo_##field(struct module *mod, const char *s)  \
>>  static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
>>  			struct module_kobject *mk, char *buffer)      \
>>  {                                                                     \
>> -	return sprintf(buffer, "%s\n", mk->mod->field);               \
>> +	return scnprintf(buffer, PAGE_SIZE, "%s\n", mk->mod->field);  \
>>  }                                                                     \
>>  static int modinfo_##field##_exists(struct module *mod)               \
>>  {                                                                     \
>> -- 
>> 1.7.7.6
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Chen Gang
