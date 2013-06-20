Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552Ab3FTCB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:01:26 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:43958 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTCBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130619111341.GH2426@book.gsilab.sittig.org>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
	<1371527778-5236-6-git-send-email-chao.xie@marvell.com>
	<201306191022.51630.marex@denx.de>
	<CADApbeiQWOi8SYEFf0bOsf1yn+TgXhwgDWaWFpGk7+nbC9bNDg@mail.gmail.com>
	<20130619111341.GH2426@book.gsilab.sittig.org>
Date: Thu, 20 Jun 2013 10:01:24 +0800
Message-ID: <CADApbehrJ=Jy_Z57serKuDm+-6_oy94QbrJUxL17HCKokDov8A@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] input: pxa27x-keypad: add device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Chao Xie <xiechao.mail@gmail.com>, Marek Vasut <marex@denx.de>,
        stefan@openezx.org, Eric Miao <eric.y.miao@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, slapin@ossfans.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <chao.xie@marvell.com>, laforge@openezx.org,
        linux-input@vger.kernel.org, sleep_walker@suse.cz,
        Robert Jarzmik <robert.jarzmik@free.fr>, drwyrm@gmail.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 7:13 PM, Gerhard Sittig <gsi@denx.de> wrote:
> On Wed, Jun 19, 2013 at 16:38 +0800, Chao Xie wrote:
>>
>> On Wed, Jun 19, 2013 at 4:22 PM, Marek Vasut <marex@denx.de> wrote:
>> >
>> >> Signed-off-by: Chao Xie <chao.xie@marvell.com>
>> >> [ ... ]
>> >> +++ b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
>> >> @@ -0,0 +1,60 @@
>> >> +* Marvell PXA Keypad controller
>> >> +
>> >> +Required Properties
>> >> +- compatible : should be "marvell,pxa27x-keypad"
>> >> +- reg : Address and length of the register set for the device
>> >> +- interrupts : The interrupt for the keypad controller
>> >> +- marvell,debounce-interval : How long time the key will be
>> >
>> > Is there no generic prop name for this debounce interval?
>> >
>> I searched at drivers/input and Documents.
>> Two drivers use "debounce-interval", gpio-keys.c and stmpe-keypad.c.
>> They describe the meanings of "debounce-interval" at its own document file.
>> Some other drivers uses "xxx,debounce-delay-ms" or "debounce-delay-ms"
>> So it seems that there is no generic prop name for this debounce interval.
>
> Actually there is, but under a different (more user friendly)
> name:  See the 'debounce-delay-ms' property in
> Documentation/devicetree/bindings/input/gpio-matrix-keypad.txt
> which gets referenced in the matrix_keypad_parse_dt() routine in
> the drivers/input/keyboard/matrix_keypad.c source file.  Ah, your
> last sentence mentions that fact.
>
> But when you introduce DT support into an existing driver which
> previously used platform data, then there is no problem with
> backwards compatibility in .dts files.  So I suggest to go with
> the "debounce-delay-ms" name since it better reflects to the .dts
> author (hardware engineer) which unit the number is supposed to
> be specified in.
>
So Arnd
What do you think? I am fine with either one.

>
> Note that I've recently worked on extending the matrix keypad
> input driver (doc improvements, software polling, binary encoded
> column selection), but haven't submitted the patch series yet
> since it's perfectly operational on the target which motivated
> the extension but wasn't tested yet on any other platform or
> matrix setup -- I currently lack access to an ARM based board
> with either lots of accessible GPIOs to connect a matrix to, or
> some matrix already built into the board, but more importantly
> lack free resources for this very driver extension.
>
> Alternatively I might send an RFC series since the current state
> isn't good enough for v1.  Just ask if you'd like to test or
> review what I have come up with so far (it builds but wasn't
> run-tested).
>
Sure, i can help you to test at PXA platform which is ARM based.

>
> virtually yours
> Gerhard Sittig
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
> Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
