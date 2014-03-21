Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbaCUI2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:28:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaCUI2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:28:02 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-e3-532bf811d134
Message-id: <532BF80F.1080602@samsung.com>
Date: Fri, 21 Mar 2014 09:27:59 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH/RFC 1/8] leds: Add sysfs and kernel internal API for flash
 LEDs
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-2-git-send-email-j.anaszewski@samsung.com>
 <1395329301.27611.4.camel@ted>
In-reply-to: <1395329301.27611.4.camel@ted>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xa7qCP7SDDeZcZLK4te4cq8XRnROZ
	LOYfAbLONr1ht7i8aw6bxdY36xgtejZsZbX48Wwiq8XhN+2sDpweO2fdZffYP3cNu0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlTFmzmb3gEW/F9pvlDYxTubsYOTkkBEwk/rz8yARhi0lc
	uLeerYuRi0NIYCmjxNb3cxghnM+MEjs//2IGqeIV0JL48bqdEcRmEVCVmHOrlQXEZhMwlPj5
	4jXYJFGBCIk/p/exQtQLSvyYfA+sRkTAXOJn5yqwDcwCjxglzvbcBEsIC4RK9M3fywSxbQWj
	xKyDJ9hBEpwC2hLrV34Hm8QsYCbxqGUdM4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVNL
	kwuKk9JzjfSKE3OLS/PS9ZLzczcxQkL+6w7GpcesDjEKcDAq8fBWcGoHC7EmlhVX5h5ilOBg
	VhLhnf4ZKMSbklhZlVqUH19UmpNafIiRiYNTqoFR4l3nw/wLTl6RRml9EbeFzHed+9tTls88
	R2tl868nt3ldog+dMJX5yT1RrymNP+CsuPCU6+8nWZ473rxpY+T+Z81/zP+V6c+KmHX0YDhv
	lOXNr8U3j6Z99BTo+8X63SGY//GJyT1Pa2JzrJIVFKZ+2n3Y8dWnO/XlnruqK7vO37uzs2f2
	vZvtSizFGYmGWsxFxYkA6TdeEVcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 04:28 PM, Richard Purdie wrote:
> On Thu, 2014-03-20 at 15:51 +0100, Jacek Anaszewski wrote:
>> Some LED devices support two operation modes - torch and
>> flash. This patch provides support for flash LED devices
>> in the LED subsystem by introducing new sysfs attributes
>> and kernel internal interface. The attributes being
>> introduced are: flash_mode, flash_timeout, max_flash_timeout,
>> flash_fault and hw_triggered.
>> The modifications aim to be compatible with V4L2 framework
>> requirements related to the flash devices management. The
>> design assumes that V4L2 driver can take of the LED class
>> device control and communicate with it through the kernel
>> internal interface. The LED sysfs interface is made
>> unavailable then.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   drivers/leds/led-class.c    |  216 +++++++++++++++++++++++++++++++++++++++++--
>>   drivers/leds/led-core.c     |  124 +++++++++++++++++++++++--
>>   drivers/leds/led-triggers.c |   17 +++-
>>   drivers/leds/leds.h         |    9 ++
>>   include/linux/leds.h        |  136 +++++++++++++++++++++++++++
>>   5 files changed, 486 insertions(+), 16 deletions(-)
>
> It seems rather sad to have to insert that amount of code into the core
> LED files for something which only a small number of LEDs actually use.
> This will increase the footprint of the core LED code significantly.
>
> Is it not possible to add this as a module/extension to the LED core
> rather than completely entangling them?

OK, I'll try to decouple it.

Thanks,
Jacek Anaszewski

