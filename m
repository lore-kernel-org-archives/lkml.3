Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaIDRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:19:56 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40074 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaIDRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <5404246E.4090908@de.bosch.com>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
	<20140829190129.GZ29327@sirena.org.uk>
	<5404246E.4090908@de.bosch.com>
Date: Thu, 4 Sep 2014 19:19:54 +0200
Message-ID: <CACRpkdZgUvcJZ=GkGBUjBdxD_=9bjK9jOiQb798c3=g=4QLwMg@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Mark Brown <broonie@kernel.org>,
        Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 9:46 AM, Dirk Behme <dirk.behme@de.bosch.com> wrote:
> On 29.08.2014 21:01, Mark Brown wrote:

>> Any current boards should be using DT and so shouldn't be using fixed
>> GPIO numbers in the first place which will mean they'll not end up
>> getting zero as a valid GPIO.
>
> Hmm? What's wrong with a DT entry
>
> <&gpio1 0 0>;
>
> for ena_gpio resulting in zero as a valid GPIO?

I don't know if it's relevant to the discussion but that is
not GPIO #0 in the global GPIO numberspace, it is
*offset* zero on some gpio_chip named gpio1.

At probe time that chip is given some base offset
and offset 0 becomes the global GPIO number
(base+offset) so if that GPIO chip starts from 128
this indicates global GPIO number 128.

Or something totally different. It's a Linux-specific
implementation detail, all DT GPIO notations are
relative offsets.

Yours,
Linus Walleij
