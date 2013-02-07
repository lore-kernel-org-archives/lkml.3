Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3BGPR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:17:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:15650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab3BGPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,622,1355126400"; 
   d="scan'208";a="199730583"
Message-ID: <5113C595.3070402@linux.intel.com>
Date: Thu, 07 Feb 2013 07:17:41 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: gpio-sch GPIO_SYSFS access
References: <5112FC44.2000303@linux.intel.com> <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
In-Reply-To: <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2013 02:09 AM, Linus Walleij wrote:
> On Thu, Feb 7, 2013 at 1:58 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> 
>> Is it that some other driver has claimed these GPIO lines? If so, how do
>> I determine which one?
> 
> Yes I think that could be it, the driver would need to call
> gpio_export() for it to also be accessible in sysfs.

Do you mean gpiochip_export()?

Hrm, neither gpio-pch nor gpio-sch call gpiochip_export() directly. They
both call gpiochip_add() and that calls gpiochip_export() unconditionally.
As far as I could tell, both drivers call gpiochip_export().

I thought maybe the sch happened to early, maybe hitting the the
pre-driver-model-support note in gpiochip_export(), but it runs after
the pch chip for some reason, and that one is fine. I suppose I could be
failing on device_create or sysfs_create_group and just not seeing the
output. I'll try to get DYNAMIC_DEBUG and pr_debug in gpiolib.c working
(that always seems to be an unnecessarily arduous exercise).

> 
> Configure in debugfs and check the file "gpio" in debugfs
> to figure out the client.

That file contained only the gpiochip244 from the gpio-pch driver,
nothing from the sch.

Thanks!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
