Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3FJNj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:39:28 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38874 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3FJNj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <201306101506.36098.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
	<CACRpkdaV0ipY4mYHt998D=NNKrpDaFhCA949V0-93NkOKcvHyA@mail.gmail.com>
	<201306101506.36098.heiko@sntech.de>
Date: Mon, 10 Jun 2013 15:39:26 +0200
Message-ID: <CACRpkdbnf2MJtnYrwGMVWyz4S=7tuDKv84p7eNgveSNCeLv15g@mail.gmail.com>
Subject: Re: [PATCH 0/2] pinctrl: common handling of generic pinconfig props
 in dt
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 3:06 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 10. Juni 2013, 14:52:13 schrieb Linus Walleij:
>> On Sun, Jun 9, 2013 at 1:59 AM, Heiko Stübner <heiko@sntech.de> wrote:
>> > following your suggestions for a common handling of things like pulls in
>> > dt, I've come up with the following solution - hopefully I've gotten the
>> > correct meaning of your explanaitions.
>> >
>> > It handles all the pinconfigs that either ignore the argument, or have
>> > very simple one, like PIN_CONFIG_OUTPUT does.
>>
>> OK patches applied. It needs some rough fixes like NULL check
>> on kmalloc() but it'll do for a starter.
>
> gah, sorry ... I have urge to crawl under a rock now for forgetting something
> this obvious ;-) .
>
> Apart from the NULL check what more did I mess up? Should I send a fixup patch
> or do you want to do it?

I can fix this.

But now I just wondered about one thing:

Does this design imply that we will never be able to support any
more than 32 bits (well, the number of bits in unsigned long)
i.e. 32 different generic pin configurations?

In that case I suspect this might not be so wise. :-(

What about instead of using bitstuffed numbers using some
representation similar to what can be found in
Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

So instead of using <dt-bindings/pinctrl/pinconfig.h> and
enumerators it would be more like using node properties
like this:

my_config: my_config {
        bias-disable;
        drive-push-pull = <6>;
        output-high;
};

It will make the device trees bigger for sure, but maybe more
readable as well?

Yours,
Linus Walleij
