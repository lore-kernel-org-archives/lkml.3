Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaJFLdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:33:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35400 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbaJFLdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:33:33 -0400
Date: Mon, 6 Oct 2014 12:33:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 04/11] pwm: add DT bindings documentation for
 atmel-hlcdc-pwm driver
Message-ID: <20141006113326.GG24686@leverpostej>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-5-git-send-email-boris.brezillon@free-electrons.com>
 <20141006101350.GD25202@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006101350.GD25202@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 11:13:51AM +0100, Thierry Reding wrote:
> On Wed, Oct 01, 2014 at 04:53:01PM +0200, Boris Brezillon wrote:
> > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > 
> > The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
> > at91sam9x5 family or sama5d3 family) provide a PWM device.
> > 
> > The DT bindings used for this PWM device is following the default 3 cells
> > bindings described in Documentation/devicetree/bindings/pwm/pwm.txt.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    | 55 ++++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> > new file mode 100644
> > index 0000000..86ad3e2
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> > @@ -0,0 +1,55 @@
> > +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM driver
> > +
> > +The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
> > +See ../mfd/atmel-hlcdc.txt for more details.
> > +
> > +Required properties:
> > + - compatible: value should be one of the following:
> > +   "atmel,hlcdc-pwm"
> > + - pinctr-names: the pin control state names. Should contain "default".
> > + - pinctrl-0: should contain the pinctrl states described by pinctrl
> > +   default.
> > + - #pwm-cells: should be set to 3. This PWM chip use the default 3 cells
> > +   bindings defined in Documentation/devicetree/bindings/pwm/pwm.txt.
> > +   The first cell encodes the PWM id (0 is the only acceptable value here,
> > +   because the chip only provide one PWM).
> > +   The second cell encodes the PWM period in nanoseconds.
> > +   The third cell encodes the PWM flags (the only supported flag is
> > +   PWM_POLARITY_INVERTED)
> 
> Given that this already refers to the default 3 cells binding it doesn't
> need to repeat part of the contents of pwm.txt.

Given that pwm.txt states:

pwm-specifier : array of #pwm-cells specifying the given PWM 
                (controller specific)

I'd leave it here. Just because pwm.txt gives an example of a controller
specific meaning for the pwm cells, I don't think we should rely on it
everywhere.

Mark.
