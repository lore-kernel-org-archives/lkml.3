Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaJFQC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:02:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753262AbaJFQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:02:22 -0400
Date: Mon, 6 Oct 2014 18:02:17 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 06/11] drm: add DT bindings documentation for
 atmel-hlcdc-dc driver
Message-ID: <20141006180217.3b98a67e@bbrezillon>
In-Reply-To: <20141006142608.GA1744@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
	<20141006105433.GG25202@ulmo>
	<20141006141440.32fae2ef@bbrezillon>
	<20141006123506.GC26833@ulmo>
	<20141006155358.61a2a30c@bbrezillon>
	<20141006142608.GA1744@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 16:26:10 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Mon, Oct 06, 2014 at 03:53:58PM +0200, Boris Brezillon wrote:
> > On Mon, 6 Oct 2014 14:35:06 +0200
> > Thierry Reding <thierry.reding@gmail.com> wrote:
> > 
> > > On Mon, Oct 06, 2014 at 02:14:40PM +0200, Boris Brezillon wrote:
> > > > On Mon, 6 Oct 2014 12:54:34 +0200
> > > > Thierry Reding <thierry.reding@gmail.com> wrote:
> > > > 
> > > > > On Wed, Oct 01, 2014 at 04:53:03PM +0200, Boris Brezillon wrote:
> > > > > > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > > > 
> > > > > > The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.e.
> > > > > > at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
> > > > > > controller device.
> > > > > > 
> > > > > > The HLCDC block provides a single RGB output port, and only supports LCD
> > > > > > panels connection to LCD panels for now.
> > > > > > 
> > > > > > The atmel,panel property link the HLCDC RGB output with the LCD panel
> > > > > > connected on this port (note that the HLCDC RGB connector implementation
> > > > > > makes use of the DRM panel framework).
> > > > > > 
> > > > > > Connection to other external devices (DRM bridges) might be added later by
> > > > > > mean of a new atmel,xxx (atmel,bridge) property.
> > > > > > 
> > > > > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > > > > ---
> > > > > >  .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     | 53 ++++++++++++++++++++++
> > > > > >  1 file changed, 53 insertions(+)
> > > > > >  create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > > > > new file mode 100644
> > > > > > index 0000000..ebc1a91
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > > > > @@ -0,0 +1,53 @@
> > > > > > +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) DRM driver
> > > > > > +
> > > > > > +The Atmel HLCDC Display Controller is subdevice of the HLCDC MFD device.
> > > > > > +See ../mfd/atmel-hlcdc.txt for more details.
> > > > > > +
> > > > > > +Required properties:
> > > > > > + - compatible: value should be "atmel,hlcdc-display-controller"
> > > > > > + - pinctrl-names: the pin control state names. Should contain "default".
> > > > > > + - pinctrl-0: should contain the default pinctrl states.
> > > > > > + - #address-cells: should be set to 1.
> > > > > > + - #size-cells: should be set to 0.
> > > > > > +
> > > > > > +Required children nodes:
> > > > > > + Children nodes are encoding available output ports and their connections
> > > > > > + to external devices using the OF graph reprensentation (see ../graph.txt).
> > > > > > + At least one port node is required.
> > > > > 
> > > > > Are the connections configurable at runtime? Does the SoC have IP blocks
> > > > > for HDMI or other types of outputs or does it provide only RGB output to
> > > > > external blocks?
> > > > 
> > > > No, there's only one RGB output port, but you can connect more than one
> > > > device on the RGB port (should we call it DPI port ?).
> > > > Actually Atmel connected an HDMI encoder and an LCD panel connected on
> > > > the same port on their dev kit.
> > > 
> > > This was discussed in some other thread if I remember correctly. I still
> > > think that the HLCDC node should only contain a single output, no matter
> > > how many encoders or panels get connected.
> > > 
> > > So the output represents the set of signals that exit the IP block, but
> > > what's connected to them on the board is a board-level detail and
> > > therefore should go into the board DTS.
> > > 
> > > In the above case of the Atmel devkit, is there any way to control where
> > > the signal goes or does it just go to both the panel and HDMI encoder at
> > > the same time and it's up to the user to properly configure the output
> > > in order to get either HDMI or panel to display anything?
> > 
> > No there's no way to control where the signal goes.
> > What you can control though, is the activation of the associated
> > encoder/connectors connected on this bus (using dpms).
> 
> But the bus is really only the CRTC, so using DPMS for this is not how
> it's usually done in DRM. Can't you model both outputs as separate
> encoders and then attach them to the CRTC? This should work
> automatically for the framebuffer console and any userspace that can
> talk KMS.

That's exactly what I'm proposing, except there's a layer in between
handling the video bus format configuration.

I just sent you an RFC, proposing an implementation of the DPI/raw-RGB
bus layer.

> 
> Perhaps that's already what's being done and I misunderstand what you're
> saying. I should go back to reviewing the DRM driver. I started this
> morning, then got interrupted by other things.

No problem. I'm glad to see that things are eventually moving on.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
