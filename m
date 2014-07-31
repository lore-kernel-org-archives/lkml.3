Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaGaSwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:52:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:50237 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaGaSwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <53DA7993.1000800@suse.de>
References: <1406822910-6255-1-git-send-email-afaerber@suse.de>
 <1406822910-6255-5-git-send-email-afaerber@suse.de> <CAP_ceTz+KRJzF9XV=_aLE+6sV6d5GqCtQ_daKtpFJfCZQ1erpA@mail.gmail.com>
 <53DA7993.1000800@suse.de>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Thu, 31 Jul 2014 11:51:57 -0700
X-Google-Sender-Auth: PG1Hcz3IHjIiY5_USuwTBkbLubA
Message-ID: <CAP_ceTx3uTS=CVP0qpB5u8Dk69kZvWwPBVTCBPX8+cz0uTOXFw@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
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

On Thu, Jul 31, 2014 at 10:14 AM, Andreas Färber <afaerber@suse.de> wrote:
> Hi,
>
> Am 31.07.2014 19:00, schrieb Vincent Palatin:
>> Always a bit late to the game.
>> One small comment inline.
>>
>> Reviewed-by: Vincent Palatin <vpalatin@chromium.org>
>
> Thanks,
>
>>
>> On Thu, Jul 31, 2014 at 9:08 AM, Andreas Färber <afaerber@suse.de> wrote:
>>> +       usb3_vbus_reg: regulator-usb3 {
>>> +               compatible = "regulator-fixed";
>>> +               regulator-name = "P5.0V_USB3CON";
>>> +               regulator-min-microvolt = <5000000>;
>>> +               regulator-max-microvolt = <5000000>;
>>> +               gpio = <&gpe1 0 GPIO_ACTIVE_LOW>;
>>> +               enable-active-high;
>>> +       };
>>
>> GPE1_0 GPIO is the HSIC hub (SMSC 3503) reset# line (already defined
>> below afaik).
>
> Yes, that was a suggestion you made on v1.
>
>> On this design there is no external USB3 port, so no VBUS reg/load
>> switch for USB3.
>
> Could you be a little clearer? Are you suggesting to drop the gpio
> property? I just re-tested that without the regulator node plus the
> vbus-supply below I don't get any USB2 (so maybe rename the regulator?).

The 3503 PHY driver is not fully correct, so we probably need to keep
this to get the right init timings when the bootloader has initiliazed
it before.
but yes renaming the regulator to mention that's actually the hsic hub
reset would make it clearer.


>>> +
>>> +       usb@12110000 {
>>> +               samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
>>> +       };
>>> +
>>> +       usb-hub {
>>> +               compatible = "smsc,usb3503a";
>>> +               reset-gpios = <&hsic_reset>;
>>> +       };
> [...]
>>> +&usbdrd_phy {
>>> +       vbus-supply = <&usb3_vbus_reg>;
>>> +};
>>> +
>>> +#include "cros-ec-keyboard.dtsi"
>>> --
>>> 1.9.3
>
> --
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
> GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
