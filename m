Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3CKTqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:46:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49454 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:46:07 -0400
Message-ID: <513E347B.2020509@wwwdotorg.org>
Date: Mon, 11 Mar 2013 13:46:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] rtc: tegra: use module_platform_driver_probe for
 module init/exit
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com> <1362852588-13362-4-git-send-email-ldewangan@nvidia.com> <513E1153.20207@wwwdotorg.org> <513E30A5.8020104@nvidia.com>
In-Reply-To: <513E30A5.8020104@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:29 PM, Laxman Dewangan wrote:
> On Monday 11 March 2013 10:46 PM, Stephen Warren wrote:
>> On 03/09/2013 11:09 AM, Laxman Dewangan wrote:
>>> Use macro module_platform_driver_probe() to reduce some of the
>>> boilerplate code in the driver.

>>> diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c

>>>   -static int __init tegra_rtc_init(void)
>>> -{
>>> -    return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
>>> -}
>>> -module_init(tegra_rtc_init);
>>> -
>>> -static void __exit tegra_rtc_exit(void)
>>> -{
>>> -    platform_driver_unregister(&tegra_rtc_driver);
>>> -}
>>> -module_exit(tegra_rtc_exit);
>>> +module_platform_driver_probe(tegra_rtc_driver, tegra_rtc_probe);
>>
>> Out of curiosity here, why not just module_platform_driver(); can't the
>> instantiation of the RTC device be driven by the presence of the DT
>> node, and hence the creation of the platform device object, just like
>> any other driver/device?
> 
> Theoretically it should work but I will work with John (original author)
> about using the platform_driver_probe().
> If he agrees then  I will send patch to convert it to
> module_platform_driver().

OK, sounds good. Thanks.

