Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3HEJbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:31:48 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43558 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3HEJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:31:47 -0400
Message-ID: <51FF70FE.1090804@gmail.com>
Date: Mon, 05 Aug 2013 11:31:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: add sanity check to i2c_put_adapter
References: <1375359046-17472-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130805090030.GC2980@katana>
In-Reply-To: <20130805090030.GC2980@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 11:00, Wolfram Sang wrote:
> On Thu, Aug 01, 2013 at 02:10:46PM +0200, Sebastian Hesselbarth wrote:
>> i2c_put_adapter dereferences i2c_adapter pointer passed without check
>> for NULL. This adds a check for non-NULL pointer to allow i2c_put_adapter
>> called with NULL and behave the same way i2c_release_client does already.
>
> What about using WARN for the NULL case to point out the ref-counting
> imbalance?

Wolfram,

I was just adding this to (a) make it consistent with i2c_release_client
and (b) it allows to simplify drivers where you need to release the
adapter during probe failures. But that patch is so small, feel free to
squash in anything you like.

For a more sophisticated (WARN_ON) approach, I suggest to also put one
into i2c_release_client then.

Sebastian

>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Wolfram Sang <wsa@the-dreams.de>
>> Cc: linux-i2c@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/i2c/i2c-core.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>> index f32ca29..d075df6 100644
>> --- a/drivers/i2c/i2c-core.c
>> +++ b/drivers/i2c/i2c-core.c
>> @@ -1825,7 +1825,8 @@ EXPORT_SYMBOL(i2c_get_adapter);
>>
>>   void i2c_put_adapter(struct i2c_adapter *adap)
>>   {
>> -	module_put(adap->owner);
>> +	if (adap)
>> +		module_put(adap->owner);
>>   }
>>   EXPORT_SYMBOL(i2c_put_adapter);
>>
>> --
>> 1.7.10.4
>>

