Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbaGDW4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:56:04 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62978 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbaGDWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:55:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+ZWy1He1CxTh+GmHtwow0P=vX_9u0P67-p_ntpqDQGtg@mail.gmail.com>
References: <CAAVeFuLMLfa-1RhcdSrKDUz7=eLqZurBSFSsN7N0x-0S+_btJA@mail.gmail.com>
	<1401906155-10543-1-git-send-email-berthe.ab@gmail.com>
	<1401906155-10543-3-git-send-email-berthe.ab@gmail.com>
	<CAAVeFu+ZWy1He1CxTh+GmHtwow0P=vX_9u0P67-p_ntpqDQGtg@mail.gmail.com>
Date: Sat, 5 Jul 2014 00:55:58 +0200
Message-ID: <CACRpkdanHjyV_px8v-6VYhEk635N-vtakKrBu9cz_3TBKVV24w@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: gpiolib: set gpiochip_remove retval to void
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: abdoulaye berthe <berthe.ab@gmail.com>, Michael Buesch <m@bues.ch>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 2:12 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Thu, Jun 5, 2014 at 3:22 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

>> This avoids handling gpiochip remove error in device
>> remove handler.
>>
(...)
>> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
>> -               list_del(&chip->list);
>> +               if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
>> +                       panic("gpio: removing gpiochip with gpios still requested\n");
>
> Really, really I don't think we should panic here.

Nope dev_crit() is the right thing, with a big fat warning message.

Yours,
Linus Walleij
