Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaATJyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:54:50 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:39175 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaATJys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:54:48 -0500
Date: Mon, 20 Jan 2014 10:54:10 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 16/24] drm/i2c: tda998x: add DT documentation
Message-ID: <20140120105410.15705f32@armhf>
In-Reply-To: <CAOesGMi96wkHM8jfHNVnM7RJyW2vVoP6FT4YyYzKp-kfc0jTuQ@mail.gmail.com>
References: <cover.1390153344.git.moinejf@free.fr>
	<20140119195844.0c975b90@armhf>
	<CAOesGMi96wkHM8jfHNVnM7RJyW2vVoP6FT4YyYzKp-kfc0jTuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jan 2014 20:06:09 -0800
Olof Johansson <olof@lixom.net> wrote:

> Hi,
> 
> On Sun, Jan 19, 2014 at 10:58 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> >  .../devicetree/bindings/drm/i2c/tda998x.txt        | 24 ++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> 
> Please cc bindings for review to devicetree@vger.kernel.org (cc:d here now)
> 
> > diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> > new file mode 100644
> > index 0000000..72da71d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
> > @@ -0,0 +1,24 @@
> > +Device-Tree bindings for the NXP TDA998x HDMI transmitter
> > +
> > +Required properties;
> > +  - compatible: must be "nxp,tda998x"
> > +
> > +Optional properties:
> > +  - interrupts: interrupt number for HDMI exchanges - default: by polling
> 
> What are HDMI exchanges, and how do they differ from other interrupts?

The used HDMI interrupt events are screen plug/unplug and EDID read.
There are also CEC read/write which are not yet implemented in the
tda998x driver.

There is no difference from normal interrupts, except that the events
may be get by polling, so, the interrupt number is optional.

> > +
> > +  - pinctrl-0: pin control group to be used for this controller (IRQ).
> > +
> > +  - pinctrl-names: must contain a "default" entry.
> > +
> > +  - video-ports: 24 bits value - default: <0x230145>
> 
> What is this?

The video-ports value defines how the video controller is connected to
the tda998x chip. Each 4 bits value tells from which input pins comes
the video data and if there is any bit inversion. Each byte of this
video-ports is used to load the VIP_CNTRL_{0,1,2} registers. These ones
are described in the TDA9983B documentation which is the closer
available document about the TDA998x family.

The default value is the one defined for TI boards.
A known other value is <0x234501> which is used for Russell's Armada
DRM driver in the Cubox (Marvell A510), but this driver has no DT
support.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
