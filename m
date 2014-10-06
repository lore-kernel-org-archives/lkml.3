Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJFMfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:35:13 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45543 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaJFMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:35:10 -0400
Date: Mon, 6 Oct 2014 14:35:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
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
Message-ID: <20141006123506.GC26833@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
 <20141006105433.GG25202@ulmo>
 <20141006141440.32fae2ef@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <20141006141440.32fae2ef@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 02:14:40PM +0200, Boris Brezillon wrote:
> On Mon, 6 Oct 2014 12:54:34 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Wed, Oct 01, 2014 at 04:53:03PM +0200, Boris Brezillon wrote:
> > > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > >=20
> > > The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.=
e.
> > > at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
> > > controller device.
> > >=20
> > > The HLCDC block provides a single RGB output port, and only supports =
LCD
> > > panels connection to LCD panels for now.
> > >=20
> > > The atmel,panel property link the HLCDC RGB output with the LCD panel
> > > connected on this port (note that the HLCDC RGB connector implementat=
ion
> > > makes use of the DRM panel framework).
> > >=20
> > > Connection to other external devices (DRM bridges) might be added lat=
er by
> > > mean of a new atmel,xxx (atmel,bridge) property.
> > >=20
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > ---
> > >  .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     | 53 ++++++++++++=
++++++++++
> > >  1 file changed, 53 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc=
-dc.txt
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt=
 b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > new file mode 100644
> > > index 0000000..ebc1a91
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > @@ -0,0 +1,53 @@
> > > +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) DRM dri=
ver
> > > +
> > > +The Atmel HLCDC Display Controller is subdevice of the HLCDC MFD dev=
ice.
> > > +See ../mfd/atmel-hlcdc.txt for more details.
> > > +
> > > +Required properties:
> > > + - compatible: value should be "atmel,hlcdc-display-controller"
> > > + - pinctrl-names: the pin control state names. Should contain "defau=
lt".
> > > + - pinctrl-0: should contain the default pinctrl states.
> > > + - #address-cells: should be set to 1.
> > > + - #size-cells: should be set to 0.
> > > +
> > > +Required children nodes:
> > > + Children nodes are encoding available output ports and their connec=
tions
> > > + to external devices using the OF graph reprensentation (see ../grap=
h.txt).
> > > + At least one port node is required.
> >=20
> > Are the connections configurable at runtime? Does the SoC have IP blocks
> > for HDMI or other types of outputs or does it provide only RGB output to
> > external blocks?
>=20
> No, there's only one RGB output port, but you can connect more than one
> device on the RGB port (should we call it DPI port ?).
> Actually Atmel connected an HDMI encoder and an LCD panel connected on
> the same port on their dev kit.

This was discussed in some other thread if I remember correctly. I still
think that the HLCDC node should only contain a single output, no matter
how many encoders or panels get connected.

So the output represents the set of signals that exit the IP block, but
what's connected to them on the board is a board-level detail and
therefore should go into the board DTS.

In the above case of the Atmel devkit, is there any way to control where
the signal goes or does it just go to both the panel and HDMI encoder at
the same time and it's up to the user to properly configure the output
in order to get either HDMI or panel to display anything?

Thierry

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMox6AAoJEN0jrNd/PrOhKH8P/3P04XFmMXi7at8NXB1wwVvq
p0GRQYb73x2CPlZq85Glp//cWV02BVMkk3Edwlww8P8G7sHVe8M/jt4SbciZ/Nk+
k40ZHYaiLq3jdEJcZWLV1bQxnTQa5744cEYe561Ocer3Hs9ZY4Cf0Q4HUa/KPV70
9LlvJMqBK9jA+DoGUI7N97PfFCL+b9r0+an+7g1txlo6T3gCUpUpm/6BfGRujATe
2V543TtzWa+arTGs0lLU+93IEhSV5gKCYxSqXrV29qfcxejXoR2cBYancKPy9Iqn
i3WmBfOPihc8Uxvil6fpy9sHV11ajk2PAEHHTQYgJlokq5FPHiA3+tGw3Ix0TFrH
tU7vWDUJac9ERDdiW2b159HDDck68fvYpkOk11vS/4eRVzchHtut3QtwkwwosZhP
shEM3LlEQRgDdZcVh8zmVUhmxNyJPQ0W25jARqQHt4eMfcvLIkHZ+VQFhe+gJKrS
vwSk4WTNZvHIRh327U4Yu3qi+vUNG/LsrKFqex1ruPHaxd5DK/pIxiCISJMk/TQ/
r8nvM6hlobxf9Qc8fULsS3zLmPe1kcFpFqlGHRIrJF3TwkwGLb+NKMS4s9dp224g
Z24ZBE8BemUyp4yAmQxZhgFcN3/xlH0LiVMskU52Ciywra5kivNyQmHwUeKzyB9h
aLJaFYqhevNcfJj0dohi
=O2bm
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
