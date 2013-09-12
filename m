Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3ILMXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:23:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:33535 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3ILMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi7zbGuBBaUToe7=PUJvUUT8FkdMAWzfCE0igpYiYTZSg@mail.gmail.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
	<1378817379-8238-2-git-send-email-lee.jones@linaro.org>
	<CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
	<20130910153037.GA11227@lee--X1>
	<CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
	<CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com>
	<20130911081911.GI11227@lee--X1>
	<CACRpkdY6v+LMggLBdfKc3VUPmRZXTf1zBi4a93EPhQeo21wMeQ@mail.gmail.com>
	<CAF2Aj3iPdqM-+FQ7R9MZ-6jV1Q1me9TG1P4cEGA7fSBBYH92zA@mail.gmail.com>
	<CACRpkdYfeao6bvwjq7YJhBNCoC_JVxPTwYzPPiWM0tgUQreJKg@mail.gmail.com>
	<CAOesGMi7zbGuBBaUToe7=PUJvUUT8FkdMAWzfCE0igpYiYTZSg@mail.gmail.com>
Date: Thu, 12 Sep 2013 14:23:48 +0200
Message-ID: <CACRpkdY-N_VJwdo4+y9-9==+iC_w4qSiiE2oY-hp_jgsJyxQbg@mail.gmail.com>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:36 PM, Olof Johansson <olof@lixom.net> wrote:
> [Me]
>> I don't know what is the problem with Olof's machine :-/
>
> Oh! Well, to start with apparantly u8500_defconfig doesn't have
> APPENDED_DTB enabled, which explains some of the confusion here.

Oh. Well honestly I think we will never be able to rewrite the
U8500 bootloaders, so maybe I should just send a patch adding
this to the defconfig by default.

> With that fixed (and the appropriate options to get the bootargs from
> the atags), I get as far as console probing where output stops, if I
> have DEBUG_LL on. With it disabled I get all the way up.

Yeah somewhere the bit-banging from the LL-prints that just
hammer the hardware start conflicting with the kernel control
over the same port. I guess it's the same for all users of the
PL011.

> Not sure what was going on earlier here. Maybe just as in your case it
> was a matter of cleaning out and starting fresh.

Yeah, it's scary :-/

> multi_v7_defconfig still doesn't boot though, but the failure seems to
> be lower level than any of the others, no output with DEBUG_LL on.

Probably the usual case where one system is screwing up for
another system. We'll need to look into this.

Yours,
Linus Walleij
