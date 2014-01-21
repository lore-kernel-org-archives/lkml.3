Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaAUSR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:17:58 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:48042 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaAUSR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:17:57 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140120105410.15705f32@armhf>
References: <cover.1390153344.git.moinejf@free.fr>
	<20140119195844.0c975b90@armhf>
	<CAOesGMi96wkHM8jfHNVnM7RJyW2vVoP6FT4YyYzKp-kfc0jTuQ@mail.gmail.com>
	<20140120105410.15705f32@armhf>
Date: Tue, 21 Jan 2014 10:17:56 -0800
Message-ID: <CAOesGMhngiw+f8bkfB9C4COTPksXg_ZsYA-p1r5WJ6FZuBE3KQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/24] drm/i2c: tda998x: add DT documentation
From: Olof Johansson <olof@lixom.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 1:54 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Sun, 19 Jan 2014 20:06:09 -0800
> Olof Johansson <olof@lixom.net> wrote:
>
>> Hi,
>>
>> On Sun, Jan 19, 2014 at 10:58 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
>> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>> > ---
>> >  .../devicetree/bindings/drm/i2c/tda998x.txt        | 24 ++++++++++++++++++++++
>> >  1 file changed, 24 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>>
>> Please cc bindings for review to devicetree@vger.kernel.org (cc:d here now)
>>
>> > diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>> > new file mode 100644
>> > index 0000000..72da71d
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>> > @@ -0,0 +1,24 @@
>> > +Device-Tree bindings for the NXP TDA998x HDMI transmitter
>> > +
>> > +Required properties;
>> > +  - compatible: must be "nxp,tda998x"
>> > +
>> > +Optional properties:
>> > +  - interrupts: interrupt number for HDMI exchanges - default: by polling
>>
>> What are HDMI exchanges, and how do they differ from other interrupts?
>
> The used HDMI interrupt events are screen plug/unplug and EDID read.
> There are also CEC read/write which are not yet implemented in the
> tda998x driver.
>
> There is no difference from normal interrupts, except that the events
> may be get by polling, so, the interrupt number is optional.]

Ok, then it looks like the property description is a little confusing.
I'd remove the mentioning of HDMI exchanges from it.

>> > +
>> > +  - pinctrl-0: pin control group to be used for this controller (IRQ).
>> > +
>> > +  - pinctrl-names: must contain a "default" entry.
>> > +
>> > +  - video-ports: 24 bits value - default: <0x230145>
>>
>> What is this?
>
> The video-ports value defines how the video controller is connected to
> the tda998x chip. Each 4 bits value tells from which input pins comes
> the video data and if there is any bit inversion. Each byte of this
> video-ports is used to load the VIP_CNTRL_{0,1,2} registers. These ones
> are described in the TDA9983B documentation which is the closer
> available document about the TDA998x family.
>
> The default value is the one defined for TI boards.
> A known other value is <0x234501> which is used for Russell's Armada
> DRM driver in the Cubox (Marvell A510), but this driver has no DT
> support.

Ok, this is a classic case where the binding should describe how
things are configured/wired up instead of hardcoding a register value
like this. From the data sheet there seems to be a _lot_ of settings,
so selecting the needed subset for now might be acceptable (and go
with defaults on the rest).


-Olof
