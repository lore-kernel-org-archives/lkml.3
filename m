Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab3GPQHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:07:02 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47160 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab3GPQHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:07:00 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51E51FBE.6000205@metafoo.de>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br> <1373898160-8460-5-git-send-email-otavio@ossystems.com.br> <51E5195B.3020908@kernel.org> <51E51FBE.6000205@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/5] iio: add configuration option for debug support
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 16 Jul 2013 17:06:51 +0100
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Otavio Salvador <otavio@ossystems.com.br>, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Message-ID: <a9ec6470-0312-4aca-9c0c-bc178e65898b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Lars-Peter Clausen <lars@metafoo.de> wrote:
>On 07/16/2013 11:58 AM, Jonathan Cameron wrote:
>> On 07/15/2013 03:22 PM, Otavio Salvador wrote:
>>> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>> seems a sensible facility to have available.
>> 
>> Applied to the togreg branch of iio.git
>
>Can you update the Kconfig help text?

Good point. Will fix!
>
>>> ---
>>>  drivers/iio/Kconfig  | 7 +++++++
>>>  drivers/iio/Makefile | 2 ++
>>>  2 files changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>>> index 9af763a..d1f06f2 100644
>>> --- a/drivers/iio/Kconfig
>>> +++ b/drivers/iio/Kconfig
>>> @@ -12,6 +12,13 @@ menuconfig IIO
>>>  
>>>  if IIO
>>>  
>>> +config IIO_DEBUG
>>> +	boolean "Debug support for Industrial I/O"
>>> +	depends on DEBUG_KERNEL
>>> +	help
>>> +	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
>>> +	  sysfs, and debugfs support in Industrial I/O subsystem and
>drivers.
>
>This has nothing to do with either sysfs or debugfs support.
>
>>> +
>>>  config IIO_BUFFER
>>>  	bool "Enable buffer support within IIO"
>>>  	help
>>> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
>>> index 7a3866c..6e43e5b 100644
>>> --- a/drivers/iio/Makefile
>>> +++ b/drivers/iio/Makefile
>>> @@ -2,6 +2,8 @@
>>>  # Makefile for the industrial I/O core.
>>>  #
>>>  
>>> +ccflags-$(CONFIG_IIO_DEBUG) := -DDEBUG
>>> +
>>>  obj-$(CONFIG_IIO) += industrialio.o
>>>  industrialio-y := industrialio-core.o industrialio-event.o inkern.o
>>>  industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio"
>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
