Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaHLWLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:11:55 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43045 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaHLWLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <1445128.HbmmWnRJOL@phil>
References: <1407344984-14176-1-git-send-email-dianders@chromium.org>
 <1407344984-14176-2-git-send-email-dianders@chromium.org> <CAD=FV=Wsc-Pkvg9jumdg9i1oO+T1=jtZTfbc+qE5RDrCXaaezA@mail.gmail.com>
 <1445128.HbmmWnRJOL@phil>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 12 Aug 2014 15:11:31 -0700
X-Google-Sender-Auth: YyBri4n_t21_vXzHqHzWCSw77J0
Message-ID: <CAPz6YkX2ht62Swzepd=g6bBy6w2+SJ2C2M4xvBmWbtAjRHEocg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ARM: dts: Add emmc and sdmmc to the rk3288 device tree
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, Addy Ke <addy.ke@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 3:07 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 12. August 2014, 14:06:11 schrieb Doug Anderson:
>> Heiko,
>>
>> On Wed, Aug 6, 2014 at 10:09 AM, Doug Anderson <dianders@chromium.org>
> wrote:
>> > This adds support for the sdmmc and emmc ports on the rk3288 using the
>> >
>> > currently posted driver from Addy at:
>> >   https://patchwork.kernel.org/patch/4653631/
>> >
>> > Note:
>> > * This is not baesd on Jaehoon's patch series removing the slot node,
>> >
>> >   but it does use new syntax like putting the bus width at the top
>> >   level and using the new cap-mmc-highspeed / cap-sd-highspeed.  A
>> >   future patch will modify this one to remove the slot node.
>> >
>> > Signed-off-by: Doug Anderson <dianders@chromium.org>
>> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>> > ---
>> > Changes in v3: None
>> > Changes in v2:
>> > - New patchwork link for Addy's patch
>> >
>> >  arch/arm/boot/dts/rk3288.dtsi | 22 ++++++++++++++++++++++
>> >  1 file changed, 22 insertions(+)
>> >
>> > diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> > index e7cb008..dc98a5b 100644
>> > --- a/arch/arm/boot/dts/rk3288.dtsi
>> > +++ b/arch/arm/boot/dts/rk3288.dtsi
>> > @@ -78,6 +78,28 @@
>> >
>> >                 clock-frequency = <24000000>;
>> >
>> >         };
>> >
>> > +       sdmmc: dwmmc@ff0c0000 {
>> > +               compatible = "rockchip,rk3288-dw-mshc";
>> > +               clocks = <&cru HCLK_SDMMC>, <&cru SCLK_SDMMC>;
>> > +               clock-names = "biu", "ciu";
>> > +               fifo-depth = <0x100>;
>> > +               interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
>> > +               reg = <0xff0c0000 0x4000>;
>> > +               #address-cells = <1>;
>> > +               #size-cells = <0>;
>>
>> When doing other testing I realized that I missed a:
>>   status = "disabled";
>>
>> ...from both of these two nodes.  I'm happy to repost with this fix or
>> I'm happy if you want to add to the patch when applying.
>>
>> Let me know.  Thanks!
>
> I don't really have a preference :-) . Btw. I also did plan on merging patches
> 1 +4 and 2+3 now that the slot-removal series has landed.
> Would this be ok with you?
>
> So if you want to repost, you could do this as two patches already :-).

Please repost with the status = "disabled"; the fact that they were
enabled by the dtsi was confusing to some of us at least once already
:-)

>
>
> Heiko
>
>>
>> > +       };
>> > +
>> > +       emmc: dwmmc@ff0f0000 {
>> > +               compatible = "rockchip,rk3288-dw-mshc";
>> > +               clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
>> > +               clock-names = "biu", "ciu";
>> > +               fifo-depth = <0x100>;
>> > +               interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
>> > +               reg = <0xff0f0000 0x4000>;
>> > +               #address-cells = <1>;
>> > +               #size-cells = <0>;
>> > +       };
>> > +
>> >
>> >         i2c1: i2c@ff140000 {
>> >
>> >                 compatible = "rockchip,rk3288-i2c";
>> >                 reg = <0xff140000 0x1000>;
>> >
>> > --
>> > 2.0.0.526.g5318336
>
