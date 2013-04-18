Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab3DRT5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:57:31 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:40088 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3DRT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:57:30 -0400
Message-ID: <51705025.4000107@gmail.com>
Date: Thu, 18 Apr 2013 21:57:25 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC 2/2] gpio: samsung: Remove OF support for Exynos4/5
References: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com> <1366196768-19015-1-git-send-email-s.nawrocki@samsung.com> <CACRpkdZfZtfp5U4-Ab1ufbwBWVSvpDX_F=d-utokDXP7FbQmKw@mail.gmail.com>
In-Reply-To: <CACRpkdZfZtfp5U4-Ab1ufbwBWVSvpDX_F=d-utokDXP7FbQmKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 06:35 PM, Linus Walleij wrote:
> On Wed, Apr 17, 2013 at 1:06 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com>  wrote:
>
>> -#endif
>> +        * All Samsung platforms that support device tree will use the pinctrl
>> +        * driver, hence we skip initialization of this driver if the OF tree
>> +        * is available.
>> +        */
>> +       if (of_have_populated_dt())
>> +               return -ENODEV;
>>
>>          samsung_gpiolib_set_cfg(samsung_gpio_cfgs, ARRAY_SIZE(samsung_gpio_cfgs));
>
> Oh is that how you do it? It looks fragile.
>
> Can't you check if you have the pinctrl node atleast?

But this driver won't help if there is no pinctrl node found anyway, since
any OF support is removed from it.

This way there is no need for any additional DT parsing, just to skip 
probing
of this legacy GPIO driver.

There might be something that could have gone wrong and I am missing though.

Thanks,
Sylwester
