Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3FJOId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:08:33 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:45558 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FJOIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <201306101554.21671.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
	<201306101506.36098.heiko@sntech.de>
	<CACRpkdbnf2MJtnYrwGMVWyz4S=7tuDKv84p7eNgveSNCeLv15g@mail.gmail.com>
	<201306101554.21671.heiko@sntech.de>
Date: Mon, 10 Jun 2013 16:08:30 +0200
Message-ID: <CACRpkdbmHK-qhRH6wb1E-GK2wKADoyE=ccHN=_rW1y8GkiJ5Bg@mail.gmail.com>
Subject: Re: [PATCH 0/2] pinctrl: common handling of generic pinconfig props
 in dt
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 3:54 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 10. Juni 2013, 15:39:26 schrieb Linus Walleij:
>>
>> Does this design imply that we will never be able to support any
>> more than 32 bits (well, the number of bits in unsigned long)
>> i.e. 32 different generic pin configurations?
>>
>> In that case I suspect this might not be so wise. :-(
>
> hmm, yes this would be the limit ... so back to the drawing board

Well, I'm not hopeless, if this is what everyone wants we might
need to have it like this, perhaps make it possible to extend
the config word in the device tree from 32 to 64 to 96 bits
like this, if:

= <0x00000001>;

becomes:

= <PINCONFIG_BIAS_DISABLE>;

once we hit:

= <0x80000000>;

that is maybe

= <PINCONFIG_FOO>;

and then we need to ad PINCONFIG_BAR. What to do...
Well enable the next 64 bits:

= <0x00000000 0x00000001>;

i.e.

= <PINCONFIG_NONE PINCONFIG_EXT1_BAR>;

Note necessary naming convention to remember to
put that after the other...

and then  we get to 96 bits:

= <PINCONFIG_NONE PINCONFIG_EXT1_NONE PINCONFIG_EXT2_BAZ>;

It's getting a bit ugly ...

>> my_config: my_config {
>>         bias-disable;
>>         drive-push-pull = <6>;
>>         output-high;
>> };
>>
>> It will make the device trees bigger for sure, but maybe more
>> readable as well?
>
> There was a discussion about each of the merits of the two approaches
> (bitstuffed vs. individual properties) between Tomasz Figa and Jean-Christophe
> PLAGNIOL-VILLARD a bit back if I remember correctly.

It's OK if it's bindings for a certain system where you know you
will never have more than 32 config options. But for something
generic we need to make some space.

> And it still would be possible to write short pin statements as
>
>         pins = <bank pin mux &config_node>;
>
> if I'm not mistaken.

I thinkso....

I'll take these patches out FTM so you can experiment, but I'm
ready to make a late merge of this if you can come up with something
that we agree upon to be future-safe.

Yours,
Linus Walleij
