Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3FPKjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:39:46 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:65478 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3FPKjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <2970435.N7A5210Ocy@avalon>
References: <201306102139.32444.heiko@sntech.de>
	<1862891.4yIecp615h@avalon>
	<201306141118.22663.heiko@sntech.de>
	<2970435.N7A5210Ocy@avalon>
Date: Sun, 16 Jun 2013 12:39:44 +0200
Message-ID: <CACRpkdaEVFwdLRa7YF8P7MwuTZsrqk6A_07Ce3P6fHpv0SNn=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig
 properties from a dt node
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 4:52 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 14 June 2013 11:18:22 Heiko Stübner wrote:

>> > What's the expected way to disable pull-ups in DT ? Should it be
>> > 'bias-pull-up = <0>;' or 'bias-disable;' ?
>>
>> According to the kernedoc I think both are valid and should be handled.
>> Using bias-disable is more descriptive but would also include disabling a
>> "high-impedance" or "bus-hold" bias (if supported by the hardware).
>
> OK. I still fail to see how the various bias options are supposed to interract
> together, but I don't think I'll get an answer on that.
>
>> Personally, for my rockchip stuff I go with using the
>> "bias-pull-pin-default" <-> "bias-disable".

I think bias-pull-up = <0>; should actually mean "connect the
pin to VDD" and bias-pull-down = <0>; should mean "ground
the pin".

This makes a lot of sense from the electronics side of things,
let's not create a terminology that appeals to programmers,
such that "zero always means boolean disable", because we're
dealing with electronics here.

Yours,
Linus Walleij
