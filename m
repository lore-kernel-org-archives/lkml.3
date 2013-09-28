Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3I1LPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:15:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18671 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3I1LPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:15:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 28 Sep 2013 04:15:13 -0700
Message-ID: <5246BFAC.5020306@nvidia.com>
Date: Sat, 28 Sep 2013 17:08:20 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for
 BIAS_DEFAULT
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com> <524454F3.8000402@wwwdotorg.org> <52458876.4070205@nvidia.com> <5245AD0C.7070206@wwwdotorg.org>
In-Reply-To: <5245AD0C.7070206@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 September 2013 09:36 PM, Stephen Warren wrote:
> On 09/27/2013 07:30 AM, Laxman Dewangan wrote:
>> On Thursday 26 September 2013 09:08 PM, Stephen Warren wrote:
>>> On 09/26/2013 06:48 AM, Laxman Dewangan wrote:
>>>> Recent movement of all configurations of pin in the single call of
>>>> pin_config_set(), it is aborting configuration if BIAS_PULL_PIN_DEFAULT
>>>> is selected as return of configuration.
>>>>
>>>> The original idea was to just avoid any update on register for pull
>>>> up/down
>>>> configuration if this option is selected.
>>> That doesn't sound correct. If a config option is specified in DT or the
>>> mapping table, it should be applied to HW. If someone doesn't want a
>>> particular config option applied, then it simply shouldn't be mentioned
>>> in DT or the mapping table.
>>>
>>> IIUC, BIAS_DEFAULT should be used only on HW where there is a concept of
>>> a true default bias, and in that case, that is what should be applied.
>>>
>> Hmm.. When I added the PIN_DEFAULT, I just though that do not update
>> anything in the register and implemented like that.
>> There is nothing "default" option in HW.
> The description of that pinconfig option is:
>
>> 7970cb77 (Heiko Stübner    2013-06-06 16:44:25 +0200  43)  * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  44)  *    on embedded knowledge of the controller hardware, like current mux
>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  45)  *    function. The pull direction and possibly strength too will normally
>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  46)  *    be decided completely inside the hardware block and not be readable
>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  47)  *    from the kernel side.
>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  48)  *    If the argument is != 0 pull up/down is enabled, if it is 0, the
>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  49)  *    configuration is ignored. The proper way to disable it is to use
>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  50)  *    @PIN_CONFIG_BIAS_DISABLE.
> If the HW doesn't support any concept of a default pull, I think the
> driver shouldn't support that option; it should return an error if asked
> to program it.

Yes, I will remove this option as I have not seen default option for pins.

>
>
> But what made you come across this issue? Is some pin mapping table or
> DT pinctrl node actually using that value? If so, then presumably that
> needs to be fixed, as well as removing driver support for that option.

When referring the code for the AMSAS3722 pincontrol driver, I just 
found that it is breaking the earlier code.

Removing this option makes more reasonable here and will post the next 
patch.

