Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab3KZXtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:49:19 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46546 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3KZXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:49:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMgSnW9e4M63RVWyAtqTbhj4_+Kmw_Rm71aCUUhiav25Vw@mail.gmail.com>
References: <1385492161-27624-1-git-send-email-olof@lixom.net>
	<1385493242.20100.71.camel@joe-AO722>
	<CAOesGMgSnW9e4M63RVWyAtqTbhj4_+Kmw_Rm71aCUUhiav25Vw@mail.gmail.com>
Date: Wed, 27 Nov 2013 00:49:17 +0100
Message-ID: <CACRpkdaK3Lvw+DjWTjkU-AUyHY98YWQD58Lw10COG44WvOJSgQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: pl061: print resource_size_t as %pa
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Joe Perches <joe@perches.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 8:17 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Nov 26, 2013 at 11:14 AM, Joe Perches <joe@perches.com> wrote:
>> On Tue, 2013-11-26 at 10:56 -0800, Olof Johansson wrote:

>>>       amba_set_drvdata(adev, chip);
>>> -     dev_err(&adev->dev, "PL061 GPIO chip @%08x registered\n",
>>> -             adev->res.start);
>>> +     dev_err(&adev->dev, "PL061 GPIO chip @%pa registered\n",
>>> +             &adev->res.start);
>>
>> This looks as if this should not use dev_err, but maybe dev_info
>> and maybe it should use %pR, &adev->res
>
> Yep, I have as a somewhat long-standing todo to scrub for needlessly
> elevated printk levels (err and warn) on various drivers during boot,
> thanks for shortcutting that. :)

Bah copy/paste bug from my side ...

> I'll let Linus decide on pR vs pa.

I go with the thing you tested, fixed up the commit and also
switched to dev_info().

But now I have worse PL061 problems than this.

Yours,
Linus Walleij
