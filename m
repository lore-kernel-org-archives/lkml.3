Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaAJGUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:20:16 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42859 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaAJGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:20:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAHfPSqA=xkHX1kajjYfNz2KMrnfHGdWzu9GWvSE4ZjWWZb-hQA@mail.gmail.com>
References: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
	<1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
	<52CEAEB0.80304@samsung.com>
	<CAHfPSqA=xkHX1kajjYfNz2KMrnfHGdWzu9GWvSE4ZjWWZb-hQA@mail.gmail.com>
Date: Fri, 10 Jan 2014 11:50:13 +0530
Message-ID: <CAK9yfHymqqKTdmvV0CcfzKGceQLpJJOnVYUD_GqbwJeqLLJZRA@mail.gmail.com>
Subject: Re: [PATCH 2/6 v2] crypto:s5p-sss: Add device tree support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10 January 2014 11:37, Naveen Krishna Ch <naveenkrishna.ch@gmail.com> wrote:
> Hello Tomasz,
>

[snip]
>>> *pdev)
>>>   static struct platform_driver s5p_aes_crypto = {
>>>         .probe  = s5p_aes_probe,
>>>         .remove = s5p_aes_remove,
>>> +       .id_table       = s5p_sss_ids,
>>>         .driver = {
>>>                 .owner  = THIS_MODULE,
>>>                 .name   = "s5p-secss",
>>> +               .of_match_table = s5p_sss_dt_match,
>>
>>
>> .of_match_table = of_match_ptr(s5p_sss_dt_match),
> I dint use it, Some time back there was a patchset from Sachin
> https://lkml.org/lkml/2013/9/28/61
> Please suggest me on this.

In those cases the structure was always compiled in. i.e., it was not protected
by #ifdef CONFIG_OF. Hence use of of_match_ptr was not required. of_match_ptr
abstracts this check depending on OF is enabled or not. In the case of
this (sss) driver,
since you are using CONFIG_OF to selectively compile out the code (and esp.
s5p_sss_dt_match structure), use of of_match_ptr will make the code
simpler as it
avoids the use of a dummy structure definition (the #else part of the
struct definition) when OF is
disabled. Hope this clarifies.

-- 
With warm regards,
Sachin
