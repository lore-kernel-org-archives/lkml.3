Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3DBPa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:30:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37479 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761364Ab3DBPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:30:54 -0400
Message-ID: <515AF9A9.4060407@wwwdotorg.org>
Date: Tue, 02 Apr 2013 09:30:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com> <CACRpkdY_9pEkNfp7L82nGjsjFOi-VXwPHo7_3XwjCz8XcN8osg@mail.gmail.com> <5153DC24.7040309@nvidia.com> <515459D8.4010001@nvidia.com> <CACRpkdYTcEzVMK-7V_T1qxtz1Pbw_um8pzasM=pTJ+vFnZasAg@mail.gmail.com>
In-Reply-To: <CACRpkdYTcEzVMK-7V_T1qxtz1Pbw_um8pzasM=pTJ+vFnZasAg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 03:01 AM, Linus Walleij wrote:
> On Thu, Mar 28, 2013 at 3:55 PM, Stephen Warren <swarren@nvidia.com> wrote:
>> On 03/27/2013 11:59 PM, Laxman Dewangan wrote:
>>> On Wednesday 27 March 2013 06:30 PM, Linus Walleij wrote:
>>>> On Thu, Mar 21, 2013 at 3:30 PM, Laxman Dewangan
>>>> <ldewangan@nvidia.com> wrote:
>>>>
>>>>> +#ifdef CONFIG_OF
>>>>> +static struct of_device_id of_palmas_gpio_match[] = {
>>>>> +       { .compatible = "ti,palmas-gpio"},
>>>>> +       { },
>>>>> +};
>>>>> +MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
>>>>> +#endif
>>>>
>>>> But please drop the #ifdef here unless it causes compile errors
>>>> (I don't think it will.)
>>>>
>>>
>>> I am using this table as
>>>
>>> driver.of_match_table = of_match_ptr(of_palmas_gpio_match),
>>> of_match_ptr is macro which is NULL in case of CONFIG_OF not defined.
>>> So if I remove ifdefs then it may create build warning as unused variable.
>>
>> I think Linus's point is that you can simply remove the use of
>> of_match_ptr(). The only disadvantage of doing so is that the table will
>> always be included in the object file, but it's so small that it's
>> probably not worth worrying about.
> 
> Oh I wasn't that smart :-)
> 
> But what you're saying seems true.
> 
> The of_match_ptr() is something
> I haven't quite seen before and don't quite understand the
> semantics of, why would we use that?

Very roughly,

of_match_ptr(x) == CONFIG_OF ? x : NULL

(although with ifdefs rather than the ternary operator)

So, if you have ifdef'd the match table with CONFIG_OF, and reference it
from code outside that ifdef, then you need to use of_match_ptr() to
reference the table, so it isn't referenced when CONFIG_OF is not
defined, and hence never causes link problems.
