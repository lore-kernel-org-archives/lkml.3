Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3C1GBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:01:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2808 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3C1GBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:01:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 27 Mar 2013 23:01:22 -0700
Message-ID: <5153DC24.7040309@nvidia.com>
Date: Thu, 28 Mar 2013 11:29:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com> <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com>
In-Reply-To: <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013 06:30 PM, Linus Walleij wrote:
> On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> +#ifdef CONFIG_OF
>> +static struct of_device_id of_palmas_gpio_match[] = {
>> +       { .compatible = "ti,palmas-gpio"},
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
>> +#endif
> But please drop the #ifdef here unless it causes compile errors
> (I don't think it will.)
>

I am using this table as

driver.of_match_table = of_match_ptr(of_palmas_gpio_match),
of_match_ptr is macro which is NULL in case of CONFIG_OF not defined.
So if I remove ifdefs then it may create build warning as unused variable.

Therefore, I think it is require here.


