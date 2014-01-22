Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaAVE72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:59:28 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36267 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaAVE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:59:13 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140122013512.GT31176@beef>
References: <1390343886-25852-1-git-send-email-syin@broadcom.com>
	<CAOesGMj7wXJ+DfXzk0U1pusKqZShq+KJdPY8hh=Ffj7KDti4_Q@mail.gmail.com>
	<20140122013512.GT31176@beef>
Date: Tue, 21 Jan 2014 20:59:10 -0800
Message-ID: <CAOesGMgvGhT_VujFFFRwSwaqY1m_YwDmRp8MB=8udE5UPq8h5g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Rename Broadcom Capri pinctrl driver
From: Olof Johansson <olof@lixom.net>
To: Matt Porter <mporter@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, Mark Brown <broonie@kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 5:35 PM, Matt Porter <mporter@linaro.org> wrote:
> On Tue, Jan 21, 2014 at 04:59:35PM -0800, Olof Johansson wrote:
>> Hi,
>>
>>
>> On Tue, Jan 21, 2014 at 2:38 PM, Sherman Yin <syin@broadcom.com> wrote:
>> > To be consistent with other Broadcom drivers, the Broadcom Capri pinctrl
>> > driver and its related CONFIG option are renamed to bcm281xx.
>> >
>> > Devicetree compatible string and binding documentation use
>> > "brcm,bcm11351-pinctrl" to match the machine binding here:
>> > Documentation/devicetree/bindings/arm/bcm/bcm11351.txt
>> >
>> > This driver supports pinctrl on BCM11130, BCM11140, BCM11351, BCM28145
>> > and BCM28155 SoCs.
>> >
>> > Signed-off-by: Sherman Yin <syin@broadcom.com>
>> > Reviewed-by: Matt Porter <mporter@linaro.org>
>> > ---
>> >  ...capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} |    8 +-
>> >  arch/arm/boot/dts/bcm11351.dtsi                    |    2 +-
>> >  arch/arm/configs/bcm_defconfig                     |    2 +-
>> >  drivers/pinctrl/Kconfig                            |    8 +-
>> >  drivers/pinctrl/Makefile                           |    2 +-
>> >  .../{pinctrl-capri.c => pinctrl-bcm281xx.c}        | 1521 ++++++++++----------
>> >  6 files changed, 775 insertions(+), 768 deletions(-)
>> >  rename Documentation/devicetree/bindings/pinctrl/{brcm,capri-pinctrl.txt => brcm,bcm11351-pinctrl.txt} (98%)
>> >  rename drivers/pinctrl/{pinctrl-capri.c => pinctrl-bcm281xx.c} (25%)
>> >
>> > diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
>> > similarity index 98%
>> > rename from Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
>> > rename to Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
>> > index 9e9e9ef..c119deb 100644
>> > --- a/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
>> > +++ b/Documentation/devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt
>> > @@ -1,4 +1,4 @@
>> > -Broadcom Capri Pin Controller
>> > +Broadcom BCM281xx Pin Controller
>> >
>> >  This is a pin controller for the Broadcom BCM281xx SoC family, which includes
>> >  BCM11130, BCM11140, BCM11351, BCM28145, and BCM28155 SoCs.
>> > @@ -7,14 +7,14 @@ BCM11130, BCM11140, BCM11351, BCM28145, and BCM28155 SoCs.
>> >
>> >  Required Properties:
>> >
>> > -- compatible:  Must be "brcm,capri-pinctrl".
>> > +- compatible:  Must be "brcm,bcm11351-pinctrl"
>>
>> Since the original binding is queued for 3.14 (I believe?), if this
>> rename isn't merged for 3.14 then you will still need to accept the
>> old compatible string (binding). You can document it as deprecated,
>> but the driver needs to still probe with it.
>
> Linus had mentioned that he could take a rename in 3.14-rc for this
> driver which is really what we had in mind here. Since the binding
> doesn't become stable until 3.14 is actually released I was under the
> impression that this is ok without keeping a deprecated compatible
> string. I notice that Tomasz had comments about this type of situation
> in http://www.spinics.net/lists/devicetree/msg18010.html

Yes, if the rename goes in before the binding has been in one stable
release then we can make noncompatible changes. Which is why I said if
this isn't merged for 3.14, etc.


-Olof
