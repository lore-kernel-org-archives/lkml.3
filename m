Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3KIPeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:34:12 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54468 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3KIPeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:34:11 -0500
Message-ID: <527E55EF.5080504@linux.com>
Date: Sat, 09 Nov 2013 16:34:07 +0100
From: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Caizhiyong <caizhiyong@hisilicon.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>
Subject: Re: [PATCH] regmap: Fix compile warning with value uninitialized
References: <C3050A4DBA34F345975765E43127F10F1C08B39E@szxeml512-mbs.china.huawei.com> <20131109151626.GT2493@sirena.org.uk>
In-Reply-To: <20131109151626.GT2493@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-09 16:16 keltezéssel, Mark Brown írta:
> On Sat, Nov 09, 2013 at 09:49:11AM +0000, Caizhiyong wrote:
> 
>> @@ -2170,7 +2170,8 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
>>  			  int num_regs)
>>  {
>>  	struct reg_default *p;
>> -	int i, ret;
>> +	int i;
>> +	int ret = 0;
>>  	bool bypass;
Wouldn't the following be better?

int i, ret = 0;

I think it is more readable.

> 
> This sort of fix isn't ideal, it just silences the warning but if the
> compiler has spotted a genuine oversight in the function it won't
> address it.  It's better to include some analysis of why this is a good
> fix.
> 
The only condition when 'ret' is not set is when the num_regs parameter is zero
and krealloc doesn't fail. If the above two conditions apply, then
the code would return an uninitialized value. However, calling this function with
num_regs == 0, would be a waste as it essentially does nothing.

Also, I think code which throws warnings is worse than code
which doesn't.

-- 
Regards,
Levente Kurusa
