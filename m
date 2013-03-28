Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3C1OzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:55:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55309 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3C1OzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:55:21 -0400
Message-ID: <515459D8.4010001@nvidia.com>
Date: Thu, 28 Mar 2013 08:55:20 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com> <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com> <5153DC24.7040309@nvidia.com>
In-Reply-To: <5153DC24.7040309@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 11:59 PM, Laxman Dewangan wrote:
> On Wednesday 27 March 2013 06:30 PM, Linus Walleij wrote:
>> On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan
>> <ldewangan@nvidia.com> wrote:
>>
>>> +#ifdef CONFIG_OF
>>> +static struct of_device_id of_palmas_gpio_match[] = {
>>> +       { .compatible = "ti,palmas-gpio"},
>>> +       { },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
>>> +#endif
>>
>> But please drop the #ifdef here unless it causes compile errors
>> (I don't think it will.)
>>
> 
> I am using this table as
> 
> driver.of_match_table = of_match_ptr(of_palmas_gpio_match),
> of_match_ptr is macro which is NULL in case of CONFIG_OF not defined.
> So if I remove ifdefs then it may create build warning as unused variable.

I think Linus's point is that you can simply remove the use of
of_match_ptr(). The only disadvantage of doing so is that the table will
always be included in the object file, but it's so small that it's
probably not worth worrying about.
