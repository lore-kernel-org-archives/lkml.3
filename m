Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3EHCqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:46:23 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:60641 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3EHCqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:46:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130507162838.81a78e16234ef86e0b332275@linux-foundation.org>
References: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
	<20130507162838.81a78e16234ef86e0b332275@linux-foundation.org>
Date: Wed, 8 May 2013 10:46:21 +0800
Message-ID: <CAPgLHd_jEksFgC2nmKNoRvGeagZh5ZWXaLPkcsyxrdj=JxCGfA@mail.gmail.com>
Subject: Re: [PATCH] rtc: rtc-tile: add missing platform_device_unregister()
 when module exit
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, yongjun_wei@trendmicro.com.cn,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 07:28 AM, Andrew Morton wrote:
> On Sun, 5 May 2013 13:07:00 +0800 Wei Yongjun <weiyj.lk@gmail.com> wrote:
>
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> We have registered platform device when module init, and
>> need unregister it when module exit.
>>
>> ...
>>
>> --- a/drivers/rtc/rtc-tile.c
>> +++ b/drivers/rtc/rtc-tile.c
>> @@ -146,6 +146,7 @@ exit_driver_unregister:
>>   */
>>  static void __exit tile_rtc_driver_exit(void)
>>  {
>> +	platform_device_unregister(tile_rtc_platform_device);
>>  	platform_driver_unregister(&tile_rtc_platform_driver);
>>  }
> We don't need to do a platform_device_put(), as tile_rtc_driver_init()
> does?

platform_device_unregister() is a warp of platform_device_del() and
platform_device_put(), it is used after platform_device_add() success.
So extra platform_device_put() does not need.
 

> drivers/rtc/rtc-stmp3xxx.c appears to need the same fix.

Yes, you are right. I'll try to submit another patch to fix this unless
someone beats me at it.


>
>   
>
>


