Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975Ab3IZEFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:05:22 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:54480 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3IZEFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:05:20 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1309260004450.7439@axis700.grange>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
	<1378742636-11215-3-git-send-email-g.liakhovetski@gmx.de>
	<1681594.NCMRR5Vty1@avalon>
	<Pine.LNX.4.64.1309260004450.7439@axis700.grange>
Date: Thu, 26 Sep 2013 13:05:18 +0900
Message-ID: <CANqRtoQRqYEL1QV_i08nFZrXggxvTBfi3tDRWhw7GW1ZgOWrZA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: shmobile: r8a7790: add I2C support in Device
 Tree mode
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thu, Sep 26, 2013 at 7:10 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Laurent
>
> On Wed, 25 Sep 2013, Laurent Pinchart wrote:
>
>> Hi Guennadi,
>>
>> Thank you for the patch.
>>
>> On Monday 09 September 2013 18:03:54 Guennadi Liakhovetski wrote:
>> > This patch adds clocks and clock lookup entries for the four I2C
>> > controllers on r8a7790 and respective Device Tree nodes.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
>> > ---
>> >  arch/arm/boot/dts/r8a7790.dtsi         |   36 +++++++++++++++++++++++++++++
>> >  arch/arm/mach-shmobile/clock-r8a7790.c |   10 ++++++++
>> >  2 files changed, 46 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
>> > index 885f9f4..a5021112 100644
>> > --- a/arch/arm/boot/dts/r8a7790.dtsi
>> > +++ b/arch/arm/boot/dts/r8a7790.dtsi
>> > @@ -127,6 +127,42 @@
>> >             interrupts = <0 0 4>, <0 1 4>, <0 2 4>, <0 3 4>;
>> >     };
>> >
>> > +   i2c0: i2c@e6508000 {
>> > +           #address-cells = <1>;
>> > +           #size-cells = <0>;
>> > +           compatible = "renesas,i2c-rcar-h2";
>> > +           reg = <0 0xe6508000 0 0x40>;
>> > +           interrupt-parent = <&gic>;
>> > +           interrupts = <0 287 0x4>;
>>
>> Shouldn't you add state = "disabled" to all I2C controllers in order not to
>> enable the unused controllers by default ?
>
> It would be logical, yes, and I seem to remember having discussed this
> earlier with someone (with Magnus, IIRC), and the outcome was, that all
> Renesas .dtsi files so far define all I2C directly in enabled mode and
> that it's intentional, so, I just followed this pattern here. You can
> indeed check in other .dtsi files - all seem to do exactly the same.

Uhm, I think you mix up platform device use case and DT use case. In
the platform device case we define all devices by default, but that's
not how it should be for the DT case. In the case of DT then default
should most likely be "disabled". Please follow the direction of
Laurent.

Also, I mentioned this 25 times before already so once more cannot
hurt: "renesas,i2c-rcar-h2" needs to be replaced with something more
standard.

/ magnus
