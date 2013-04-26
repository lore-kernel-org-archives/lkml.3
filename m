Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3DZItW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:49:22 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41612 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab3DZItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <1761651.lXztZzrj1S@avalon>
References: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
	<2408684.1bsjMDDzMu@avalon>
	<CACRpkdag=YTeQH=VjW4fQ+G94REWeURhC=ErJxjmSUuP=pKYbA@mail.gmail.com>
	<1761651.lXztZzrj1S@avalon>
Date: Fri, 26 Apr 2013 10:49:12 +0200
Message-ID: <CACRpkdaMdU4DHWULnSB_dvGk8pTRbirL1HVTGqJ2rwqXR798uQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document the "GPIO mode" pitfall
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Pankaj Dev <pankaj.dev@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 1:15 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 25 April 2013 23:39:18 Linus Walleij wrote:
>> On Tue, Apr 23, 2013 at 3:33 PM, Laurent Pinchart wrote:

>> > Could you clarify the exact scope of the two configuration parameters ?
>>
>> PIN_CONFIG_OUTPUT is left a bit unspecified, but here the idea was a passive
>> drive, like just connecting the pin to VDD or GND without any driver stage
>> at all.
>
> Isn't that a driver stage ? :-)

OK something that is not a totempole type drive ...
push/pull surely implies a totempole type design.

> What is unclear to me is the interaction between OUTPUT and DRIVE_*.
> That's the part I would like to see clarified.

I sent some patch now, check it ... hm reported-by still doesn't add
you to CC :-/ better patch git-send-email...

> Does DRIVE_* imply that the pin
> is driven by the selected function, and OUTPUT imply that the pin is driven to
> a fixed level ?

That is unclear, but I suggest DRIVE* implies that everything on the pin
is driven according to that configuration. (Else it is getting ignored...)

OUTPUT would be used when you don't know the particulars or when
the driving cannot be controlled in a fine-grained manner like with the
DRIVE* configs.

Does this make sense?

> If so, how do you configure the drive type of a pin that will
> be used through the GPIO API ?

It is possible to use the pinctrl and GPIO APIs orthogonally.

For example the pinctrl can use hogs to reconfigure the pins
during sleep without intervention from the GPIO API.

So they will be fingering on the same pins registers.
Maybe even the same register (if access can be protected
properly) from different APIs.

> What about cases where I want to drive the pin
> to a fixed level in a non low-power output mode (for instance because I need
> more current that what the low-power output mode provides) ?

Just use pinconfig for that?

Is the usecase something like a power-supplying GPIO pin
and then sometimes you want to provide more power from it?

Then use pinconfig to shunt in the driver stages, and GPIO API
to enable/disable it.

Yours,
Linus Walleij
