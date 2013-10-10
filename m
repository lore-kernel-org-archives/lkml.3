Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3JJT16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:27:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:20832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab3JJT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1074,1371106800"; 
   d="scan'208";a="391248473"
Message-ID: <59573.10.7.199.145.1381433274.squirrel@linux.intel.com>
In-Reply-To: <20131010105235.GA25140@roeck-us.net>
References: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
    <1381384807-14146-10-git-send-email-david.a.cohen@linux.intel.com>
    <20131010105235.GA25140@roeck-us.net>
Date: Thu, 10 Oct 2013 12:27:54 -0700 (PDT)
Subject: Re: [PATCH v2 09/10] intel_mid: Moved board related code to a new 
     file
From: sathyanarayanan.kuppuswamy@linux.intel.com
To: "Guenter Roeck" <linux@roeck-us.net>
Cc: "David Cohen" <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        "Kuppuswamy Sathyanarayanan" 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 09, 2013 at 11:00:06PM -0700, David Cohen wrote:
>> From: Kuppuswamy Sathyanarayanan
>> <sathyanarayanan.kuppuswamy@linux.intel.com>
>>
>> +# I2C Devices
>> +obj-$(subst m,y,$(CONFIG_SENSORS_EMC1403)) += platform_emc1403.o
>> +obj-$(subst m,y,$(CONFIG_SENSORS_LIS3LV02D)) += platform_lis331.o
>
> I am a bit confused by the platform data for the above i2c devices.
> The driver for EMC1403 does supports neither interrupts nor platform data.
> The driver for LIS3LV02D supports both, but the platform data does not
> seem to match what is provided here. Am I missing something ?

I did not add anything new here. I just moved the code from mrst.c to the
respective platform data files. I am not sure whether the driver uses this
data or not. If this code needs to be fixed , we can probably do it in a
different patch.

>
>> +obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_max7315.o
>> +obj-$(subst m,y,$(CONFIG_SENSORS_MPU3050)) += platform_mpu3050.o
>
> Do you possibly mean CONFIG_INPUT_MPU3050 ?

Thanks for pointing it. I will fix it in next patchset.

>
> Guenter
>
Sathya
