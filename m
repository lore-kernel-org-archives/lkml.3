Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaAOGpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:45:40 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59838 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaAOGph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <52D019BD.30401@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389354321-32096-1-git-send-email-ch.naveen@samsung.com> <52D019BD.30401@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 15 Jan 2014 12:15:16 +0530
Message-ID: <CAHfPSqAtm-Nk1BeC3sWmtUi0dvyfweXSXYnYiQMFzzdWYiDhAg@mail.gmail.com>
Subject: Re: [PATCH 7/8 v3] crypto:s5p-sss: validate iv before memcpy
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 10 January 2014 21:33, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
>
> On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
>>
>> This patch adds code to validate "iv" buffer before trying to
>> memcpy the contents
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Changes since v2:
>> None
>>
>>   drivers/crypto/s5p-sss.c |    5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>> index f274f5f..7058bb6 100644
>> --- a/drivers/crypto/s5p-sss.c
>> +++ b/drivers/crypto/s5p-sss.c
>> @@ -381,8 +381,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>>         struct samsung_aes_variant *var = dev->variant;
>>         void __iomem *keystart;
>>
>> -       memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
>> -                               (var->aes_offset, 0), iv, 0x10);
>> +       if (iv)
>> +               memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
>> +                                       (var->aes_offset, 0), iv, 0x10);
>
>
> In what conditions can the iv end up being NULL?
req->info is the initialization vector in our case, which comes from user space.
Its good to have a check to avoid any crashes.

Also AES ECB mode does not use IV.
>
> Best regards,
> Tomasz



-- 
Shine bright,
(: Nav :)
