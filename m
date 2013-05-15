Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab3EOTHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:07:51 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39740 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab3EOTHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <51922C89.30403@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
	<CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com>
	<517A6B01.5000708@imgtec.com>
	<CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com>
	<5183AC54.30503@imgtec.com>
	<CACRpkdYYhsY-2vQnxpM-rB9_6yXiY4XBNhb4eyNvK=eD=dxK5w@mail.gmail.com>
	<5183D262.7000107@imgtec.com>
	<CACRpkdbJpnpZwoCqtFk+U9fsJXPLw+AhPBSCxawS2-QwAjBftA@mail.gmail.com>
	<51922C89.30403@imgtec.com>
Date: Wed, 15 May 2013 21:07:46 +0200
Message-ID: <CACRpkdZ5KW0qUF7vG1ZTmc0gez2T+e4KBugUGMpkXnXNmEMdEw@mail.gmail.com>
Subject: Re: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 2:22 PM, James Hogan <james.hogan@imgtec.com> wrote:

> I think that's the other way around, i.e. that's talking about mapping
> several pingroups to the same function. The next paragraph is closer to
> the problem:
>
> Documentation/pinctrl.txt
>> - PINS for a certain FUNCTION using a certain PIN GROUP on a certain
>>   PIN CONTROLLER are provided on a first-come first-serve basis, so if some
>>   other device mux setting or GPIO pin request has already taken your physical
>>   pin, you will be denied the use of it. To get (activate) a new setting, the
>>   old one has to be put (deactivated) first.
>
> In my example the tft pingroup contains all the tft pins, but I might
> want a particular pin inside that pingroup to never be controlled by the
> mux (using the per-pin mux disable (SELECT) bits).
>
> So if I use pinmux I'd have something like:
> * "tft" pingroup maps to "tft" function
> * "tft_green0" pingroup (containing individual pin inside "tft"
> pingroup) maps to "none" function to disable muxing (or the inverse,
> with each pin in use mapping to "periph" to enable muxing).
> in which case the pin has multiple muxes "controlling" it (even though
> they're sort of nested). The above paragraph seems to condemn this
> arrangement.

So if this usecase is what you want to support, why don't you just
exclude that one pin from the "tft" group and put it into another
group?

If you want it activated anyway as part of some state e.g.
"default", you can just specify multiple groups for that state.

> Or using pinconf I'd have something like:
> * "tft" pingroup maps to "tft" function
> * "tft_green0" pin (in "tft" pingroup) has pinconf "no-periph" (or the
> inverse, with each one in use having pinconf "periph")

If you want some pinconf set up for this one pin as part
of a configured state that's OK even if the pin isn't muxed
in as part of this state. muxing and config are orthogonal.

> Or modifying the pinctrl subsystem maybe something like:
> * [optional: particular named pins in] "tft" pingroup map to "tft" function
> that way enabling a mux doesn't necessarily apply to all pins in the
> group, and drivers for hardware that doesn't support partial enabling of
> the mux can reject it (I might experiment with this if I get the time).

No thanks, this will be hopeless to understand, the pinctrl
subsystem is already really hard for outsiders to understand,
let us not raise the bar even more...

Yours,
Linus Walleij
