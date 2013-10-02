Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3JBKkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:40:16 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50083 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3JBKkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <5245AD0C.7070206@wwwdotorg.org>
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
	<524454F3.8000402@wwwdotorg.org>
	<52458876.4070205@nvidia.com>
	<5245AD0C.7070206@wwwdotorg.org>
Date: Wed, 2 Oct 2013 12:40:14 +0200
Message-ID: <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 6:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> [Laxman]
>> Hmm.. When I added the PIN_DEFAULT, I just though that do not update
>> anything in the register and implemented like that.
>> There is nothing "default" option in HW.
>
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
>
> If the HW doesn't support any concept of a default pull, I think the
> driver shouldn't support that option; it should return an error if asked
> to program it.

Yes that's how I remember it and how we specified it.
Correct Heiko?

> Presumably given this, LinusW shouldn't have actually applied this
> patch, since presumably it prevents any other driver from accepting
> PIN_CONFIG_BIAS_DISABLE even in cases where it is appropriate?

There are many patches I shouldn't have applied ...

Anyway I'm not quite following, this patch affected the Palmas
driver only I think so how can it prevent any other drivers from doing
the right thing?

We'll just have to follow up with a patch that return -EINVAL for
PIN_CONFIG_BIAS_DISABLE I guess, Laxman is this what you're
doing now?

Yours,
Linus Walleij
