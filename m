Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab3CAG33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:29:29 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:36934 "EHLO mailhub2.si.c-s.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971Ab3CAG32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:29:28 -0500
Message-ID: <51304ABD.9020706@c-s.fr>
Date: Fri, 01 Mar 2013 07:29:17 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Subject: Re: [PATCH] Adds support for Open Firmware in MAX730x GPIO Driver
References: <201302220926.r1M9Q3wV029855@localhost.localdomain> <CACRpkdY1M8w7o8S4idAx1JN-fc-t221qF_uwR5U9RBsBAn=Jhw@mail.gmail.com>
In-Reply-To: <CACRpkdY1M8w7o8S4idAx1JN-fc-t221qF_uwR5U9RBsBAn=Jhw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 01/03/2013 01:43, Linus Walleij a écrit :
> On Fri, Feb 22, 2013 at 10:26 AM, Christophe Leroy
> <christophe.leroy@c-s.fr> wrote:
>
>> This patch allows the use of the MAX730x Driver on systems using
>> the Open Firmware platform format
>>
>> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> (...)
>>          /* bits_per_word cannot be configured in platform data */
>> -       spi->bits_per_word = 16;
>> +       if (spi->dev.platform_data)
>> +               spi->bits_per_word = 16;
> What about just fixing so you *can* specify that instead?
> The comment looks more like a FIXME to me.
Euh, ok, why not. But here the purpose of my patch is to allow using 
this driver with of_platform in addition to platform.
This FIXME is not mine, it was already existing in that driver.
As of_platform can configure bits per word, the only thing I did is to 
add a test in order to not apply this FIXME on the of_platform case.

Do you think my patch is not acceptable like this ?

Regards
Christophe

