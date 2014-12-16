Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaLPPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:21:35 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34765 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaLPPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAEzqOZtOycU5LT8b3SHOymMpMOMExGC9PHiZ9wHtAjxR2R5+Ew@mail.gmail.com>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
 <1418408748-9797-6-git-send-email-vishnupatekar0510@gmail.com>
 <CAGb2v65xpUhiMzSKu_1+JGNbg3oFdpw2EQ+JGUYkivCtG2O6gw@mail.gmail.com> <CAEzqOZtOycU5LT8b3SHOymMpMOMExGC9PHiZ9wHtAjxR2R5+Ew@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 16 Dec 2014 23:21:12 +0800
X-Google-Sender-Auth: eATNOSST3xQPTTyTXNBJ4ToVwDM
Message-ID: <CAGb2v65OFKkkFTpcDoW3OwToXdgRP6hLVCYY7CR7MYZ-VgckGA@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] ARM: sunxi: dts: Add note ps2 pins conflict with hdmi
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 13, 2014 at 11:18 AM, Vishnu Patekar
<vishnupatekar0510@gmail.com> wrote:
> Hello Chen-Yu,
> Thank you for pointing out styling error.
>
> On Sat, Dec 13, 2014 at 7:36 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>>
>> Hi,
>>
>> On Sat, Dec 13, 2014 at 2:25 AM, VishnuPatekar
>> <vishnupatekar0510@gmail.com> wrote:
>> > 1. Please note that ps20 pins conflict with HDMI on Lime2 Board
>> > so, by deault ps20 and ps21 are disabled for Lime2 Board.
>> > There is no on board ps2 connector and these pins can be used
>> > for different purpose.
>> >
>> > Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
>> > ---
>> >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |    6 +++++-
>> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
>> > b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
>> > index ed364d5..951b615 100644
>> > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
>> > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
>> > @@ -112,7 +112,11 @@
>> >                         pinctrl-0 = <&uart0_pins_a>;
>> >                         status = "okay";
>> >                 };
>> > -
>> > +
>> > +               /* PS2 0 and PS2 1 are disabled by default; Please note
>> > that
>> > +               ps20 pins conflict with HDMI on Lime2 Board
>> > +               */
>> > +
>>
>> Multi-line comments should be:
>>
>> /*
>>  * line 1
>>  * line 2
>>  * ...
>>  */
>
> Okie.

So, in fact this patch shouldnt be needed. The LIME2 uses the dedicated
pins for HDMI DDC. PS2 0 pins PI20 and PI21 are in fact routed to
the GPIO-2 header. They are _not_ used for HDMI. Nothing bad should
happen unless you also multiplex PI20/PI21 to HSCL/HDSA.

If you check the schematics Olimex published and trace the HDMI lines,
you will see that this is the case.

ChenYu

>>
>>
>> And why is there a delete and insert for an empty line?
>> Weird... though git seems to ignore it when applying.
>
> I used clean_patch to clear the styling error. that might have modified it.
>
>
>>
>>
>> ChenYu
>>
>> >                 i2c0: i2c@01c2ac00 {
>> >                         pinctrl-names = "default";
>> >                         pinctrl-0 = <&i2c0_pins_a>;
>> > --
>> > 1.7.9.5
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
