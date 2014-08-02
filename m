Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaHBFPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 01:15:49 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52191 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaHBFPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 01:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <53DA9BA9.60808@gmail.com>
References: <1406822910-6255-1-git-send-email-afaerber@suse.de>
	<1406822910-6255-5-git-send-email-afaerber@suse.de>
	<53DA936E.9060004@gmail.com>
	<53DA9709.10602@suse.de>
	<53DA9BA9.60808@gmail.com>
Date: Fri, 1 Aug 2014 22:15:45 -0700
X-Google-Sender-Auth: ezA33yKdIUJhg4oBxtfoNHZ0Wus
Message-ID: <CAD=FV=XVM4FUMxjindZGXku5DZ1MkTWq=Smmt_Fs7=_i4MBFKw@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jul 31, 2014 at 12:40 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Andreas,
>
> On 31.07.2014 21:20, Andreas Färber wrote:
>> Am 31.07.2014 21:05, schrieb Tomasz Figa:
>>> On 31.07.2014 18:08, Andreas Färber wrote:
>>>> Adds initial support for the HP Chromebook 11.
>>>
>>> [snip]
>>>
>>>> +   gpio-keys {
>>>> +           compatible = "gpio-keys";
>>>> +           pinctrl-names = "default";
>>>> +           pinctrl-0 = <&power_key_irq>, <&lid_irq>;
>>>> +
>>>> +           power {
>>>> +                   label = "Power";
>>>> +                   gpios = <&gpx1 3 GPIO_ACTIVE_LOW>;
>>>> +                   linux,code = <KEY_POWER>;
>>>
>>> I assume the key is debounced in hardware, so there is no need for
>>> debounce-interval here. Is this correct?
>>
>> You're asking the wrong person... This is copied from
>> -cros-common/-snow. Downstream 3.8 does not have a debounce-interval
>> property.
>
> Doug, Vincent?

Not something I've looked at, but it's never been a problem...


>>>> +&sd1_clk {
>>>> +   samsung,pin-drv = <0>;
>>>> +};
>>>> +
>>>> +&sd1_cmd {
>>>> +   samsung,pin-pud = <3>;
>>>> +   samsung,pin-drv = <0>;
>>>> +};
>>>> +
>>>> +&sd1_cd {
>>>> +   samsung,pin-drv = <0>;
>>>> +};
>>>> +
>>>> +&sd1_bus4 {
>>>> +   samsung,pin-drv = <0>;
>>>> +};
>>>
>>> Here generic settings are being overridden, so it might be a good idea
>>> to explain why, like with i2c pull-up above.
>>
>> Snow does not have an explanation either, so please suggest what comment
>> you'd like to see. Consider me just a user with no specs. :)
>
> Doug, Vincent, someone else?

The comment is just in a different place--it's in the dw_mmc node.
Probably belongs here, though:

                /*
                 * Wifi is a SiP, so can keep drive strengths low
                 * to reduce EMI.
                 */

I guess the cmd line isn't documented.  There is no external pull on
the command line and on most boards there is one.  Our hardware guys
thought we didn't need it and apparently we don't...
