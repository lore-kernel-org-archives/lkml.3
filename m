Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3EQGrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:47:08 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61808 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EQGrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <5194A30C.7040402@imgtec.com>
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
	<CACRpkdZ5KW0qUF7vG1ZTmc0gez2T+e4KBugUGMpkXnXNmEMdEw@mail.gmail.com>
	<5194A30C.7040402@imgtec.com>
Date: Fri, 17 May 2013 08:47:05 +0200
Message-ID: <CACRpkdY3dJa2BFuVot9YK+BP82JsKzxB47n2z6P_qAQ0Qr3F9Q@mail.gmail.com>
Subject: Re: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@wwwdotorg.org>
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

On Thu, May 16, 2013 at 11:12 AM, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Linus,
> On 15/05/13 20:07, Linus Walleij wrote:
>> On Tue, May 14, 2013 at 2:22 PM, James Hogan <james.hogan@imgtec.com> wrote:
>>
>>> I think that's the other way around, i.e. that's talking about mapping
>>> several pingroups to the same function. The next paragraph is closer to
>>> the problem:
>>>
>>> Documentation/pinctrl.txt
>>>> - PINS for a certain FUNCTION using a certain PIN GROUP on a certain
>>>>   PIN CONTROLLER are provided on a first-come first-serve basis, so if some
>>>>   other device mux setting or GPIO pin request has already taken your physical
>>>>   pin, you will be denied the use of it. To get (activate) a new setting, the
>>>>   old one has to be put (deactivated) first.
>>>
>>> In my example the tft pingroup contains all the tft pins, but I might
>>> want a particular pin inside that pingroup to never be controlled by the
>>> mux (using the per-pin mux disable (SELECT) bits).
>>>
>>> So if I use pinmux I'd have something like:
>>> * "tft" pingroup maps to "tft" function
>>> * "tft_green0" pingroup (containing individual pin inside "tft"
>>> pingroup) maps to "none" function to disable muxing (or the inverse,
>>> with each pin in use mapping to "periph" to enable muxing).
>>> in which case the pin has multiple muxes "controlling" it (even though
>>> they're sort of nested). The above paragraph seems to condemn this
>>> arrangement.
>>
>> So if this usecase is what you want to support, why don't you just
>> exclude that one pin from the "tft" group and put it into another
>> group?
>
> It's a very board specific thing (that was just one example). To
> generalise your suggestion would make all muxing pingroups contain no
> pins (which is perhaps accurate since the thing that's muxed by the
> group is a set of internal signals that may be muxed out to pins via the
> SELECT bits).

Well there are different ways to skin this cat.

Stephen usually says that if each pin can be muxed individually
(such as if they each have a unique control register switching that
very pin between different devices) then each pin should have its own
pin group.

Then you accumulate these groups into a state, there may be many
of them. One group per pin is perfectly legal.

Myself I've been soft on the issue. I think that is the hardware
engineers designing the pin muxing have had certain usecases in
mind, or (especially) if there are hardware restricts such that
the mux from a system point of view can just be set if it is set
on all pins in succession, we can define a group of pins for the
usecase.

You're making it sound like the one-group-per-pin is a more
viable approach in your case and that will work, but myself I
usually try to go over the usecases from a HW point of view and
think which groups make sense to combine, and come up with
a small set of groups that I combine with a function to get the
right settings for a device.

Please choose the solution you think fits your system best.

However avoid falling into the combinatorial trap, pinctrl
is not about listing all the possible *theoretical* combinations
of pins in groups, that is mathematics. We're doing practical
solutions here.

Yours,
Linus Walleij
