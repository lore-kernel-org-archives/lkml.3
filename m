Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaJFNCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:02:03 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63396 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJFNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:02:00 -0400
Message-ID: <54329424.2020204@gmail.com>
Date: Mon, 06 Oct 2014 21:07:48 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
References: <542FC27A.8050006@gmail.com> <20141006100842.GC25202@ulmo>
In-Reply-To: <20141006100842.GC25202@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/14 18:08, Thierry Reding wrote:
> On Sat, Oct 04, 2014 at 05:48:42PM +0800, Chen Gang wrote:
>> PWM_CLPS711X needs HAS_IOMEM, so depend on it, the related error (with
>> allmodconfig under um):
>>
>>     MODPOST 1205 modules
>>   ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>>   ERROR: "devm_ioremap" [drivers/net/phy/mdio-bcm-unimac.ko] undefined!
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  drivers/pwm/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index 3865dfb..de1ffb5 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -82,7 +82,7 @@ config PWM_BFIN
>>  
>>  config PWM_CLPS711X
>>  	tristate "CLPS711X PWM support"
>> -	depends on ARCH_CLPS711X || COMPILE_TEST
>> +	depends on (ARCH_CLPS711X || COMPILE_TEST) && HAS_IOMEM
> 
> Applied, thanks. I modified this slightly and put HAS_IOMEM on a line of
> its own. This is in my opinion (slightly) more readable and matches what
> we already have for other drivers.
> 

It is OK to me, thank you for your work.


-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
