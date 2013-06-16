Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3FPMgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 08:36:00 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36849 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3FPMf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 08:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <201306161302.32156.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141744.21117.heiko@sntech.de>
	<CACRpkdY6pmS=5rphvYdt_8yKYJq8ADu0omy48ncZ3LFtEUf7yg@mail.gmail.com>
	<201306161302.32156.heiko@sntech.de>
Date: Sun, 16 Jun 2013 14:35:58 +0200
Message-ID: <CACRpkdZxO-8rQPBRPsxAx8OBfwvh_BQuts7NAi379gMZG+1ocg@mail.gmail.com>
Subject: Re: [PATCH 5/5] pinctrl: rockchip: correctly handle arguments of
 pinconf options
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 1:02 PM, Heiko Stübner <heiko@sntech.de> wrote:

>> > -               *config = 0;
>> > +               pull = rockchip_get_pull(bank, pin - bank->pin_base);
>> > +               *config = (pull == param) ? 1 : 0;
>>
>> And then I guess you should emit PIN_CONFIG_BIAS_DISABLE
>> here as well.
>
> rockchip_get_pull does emit PIN_CONFIG_BIAS_DISABLE when the pull is disabled,
> only wrongly does add the argument here.

Ah, right.

> But I'm actually not quite sure what the expected behaviour is here at all :-)
>
> Say the pin is in the "pin-default" pull state and the query in config_get is
> for "bias-disable", what would be the expected bahviour/return value in this
> case?

return -EINVAL; ?

Hm it was some time since I designed this...

Yours,
Linus Walleij
