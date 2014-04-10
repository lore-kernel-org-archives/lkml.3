Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbaDJQWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:22:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51459 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaDJQWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:22:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OjnUaBE=Ma-B54=z_w5L6zDP4tn52_kwXekbj2sbYrOLA@mail.gmail.com>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
	<1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
	<CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com>
	<1396959284.28420.45.camel@iivanov-dev>
	<5343EC87.700@codeaurora.org>
	<1396964805.28420.53.camel@iivanov-dev>
	<53440544.9040502@codeaurora.org>
	<CAJAp7OjnUaBE=Ma-B54=z_w5L6zDP4tn52_kwXekbj2sbYrOLA@mail.gmail.com>
Date: Thu, 10 Apr 2014 18:22:36 +0200
Message-ID: <CACRpkdY_-fN3oxXwghR=iC7_K-xF7_-HRtBKDnGbckEsYKA+pw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Timur Tabi <timur@codeaurora.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 8:39 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Tue, Apr 8, 2014 at 7:18 AM, Timur Tabi <timur@codeaurora.org> wrote:

>> Back in July, Qualcomm submitted a patch that added this information into
>> the device tree:
>>
>> http://marc.info/?t=137185166100003&r=1&w=2
>>
>> However, this was rejected.  Now it appears that this information is again
>> being added to the device tree, but it's being accepted.  What's different
>> now?
>
> The difference is that in the first proposal pins, groups and
> functions where defined in DT, in the accepted proposal the devicetree
> merely selects pins, functions and their configuration.

Yes and I point this out in this reply:
http://marc.info/?l=linux-kernel&m=137650778624988&w=2

>> Another problem is that these device tree changes makes it difficult to
>> support ACPI.  It's easy to move information between the drivers and the
>> device tree, because they're kept together.  It's not so easy with ACPI.
>> I'm trying to add ACPI support to the 8x74 pinctrl driver, but it's a moving
>> target.
>
> The DT bindings for 8x74 is all standard pinctrl, so I presume that
> what you should be looking at is how pinctrl and acpi is interacting,
> not the specific case of 8x74...
>
> Maybe Linus have some input on this?

AFAIK ACPI has nothing like official pin control support, last time I
checked it was limited to some custom information that could be
tagged onto GPIO pins (REALLY a bad idea, we don't shoehorn
pin control into the concept of GPIO).

If you are adding this then tell me which ACPI standard document
you're using for it, so I can read and criticize it.

I was under the impression that the ambition of ACPI was to hide
away all "complex stuff" such as pin control in the firmware
and just e.g. call the devices into some D-state and the
pin business happens in the firmware.

Yours,
Linus Walleij
