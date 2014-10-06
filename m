Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaJFO0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:26:15 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35248 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJFO0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:26:14 -0400
Date: Mon, 6 Oct 2014 16:26:10 +0200
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
Message-ID: <20141006142608.GA1744@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-7-git-send-email-boris.brezillon@free-electrons.com>
 <20141006105433.GG25202@ulmo>
 <20141006141440.32fae2ef@bbrezillon>
 <20141006123506.GC26833@ulmo>
 <20141006155358.61a2a30c@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20141006155358.61a2a30c@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 03:53:58PM +0200, Boris Brezillon wrote:
> On Mon, 6 Oct 2014 14:35:06 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
>=20
> > On Mon, Oct 06, 2014 at 02:14:40PM +0200, Boris Brezillon wrote:
> > > On Mon, 6 Oct 2014 12:54:34 +0200
> > > Thierry Reding <thierry.reding@gmail.com> wrote:
> > >=20
> > > > On Wed, Oct 01, 2014 at 04:53:03PM +0200, Boris Brezillon wrote:
> > > > > From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > >=20
> > > > > The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs=
 (i.e.
> > > > > at91sam9n12, at91sam9x5 family or sama5d3 family) provides a disp=
lay
> > > > > controller device.
> > > > >=20
> > > > > The HLCDC block provides a single RGB output port, and only suppo=
rts LCD
> > > > > panels connection to LCD panels for now.
> > > > >=20
> > > > > The atmel,panel property link the HLCDC RGB output with the LCD p=
anel
> > > > > connected on this port (note that the HLCDC RGB connector impleme=
ntation
> > > > > makes use of the DRM panel framework).
> > > > >=20
> > > > > Connection to other external devices (DRM bridges) might be added=
 later by
> > > > > mean of a new atmel,xxx (atmel,bridge) property.
> > > > >=20
> > > > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.co=
m>
> > > > > ---
> > > > >  .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     | 53 ++++++++=
++++++++++++++
> > > > >  1 file changed, 53 insertions(+)
> > > > >  create mode 100644 Documentation/devicetree/bindings/drm/atmel-h=
lcdc-dc.txt
> > > > >=20
> > > > > diff --git a/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc=
=2Etxt b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > > > new file mode 100644
> > > > > index 0000000..ebc1a91
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
> > > > > @@ -0,0 +1,53 @@
> > > > > +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) DRM=
 driver
> > > > > +
> > > > > +The Atmel HLCDC Display Controller is subdevice of the HLCDC MFD=
 device.
> > > > > +See ../mfd/atmel-hlcdc.txt for more details.
> > > > > +
> > > > > +Required properties:
> > > > > + - compatible: value should be "atmel,hlcdc-display-controller"
> > > > > + - pinctrl-names: the pin control state names. Should contain "d=
efault".
> > > > > + - pinctrl-0: should contain the default pinctrl states.
> > > > > + - #address-cells: should be set to 1.
> > > > > + - #size-cells: should be set to 0.
> > > > > +
> > > > > +Required children nodes:
> > > > > + Children nodes are encoding available output ports and their co=
nnections
> > > > > + to external devices using the OF graph reprensentation (see ../=
graph.txt).
> > > > > + At least one port node is required.
> > > >=20
> > > > Are the connections configurable at runtime? Does the SoC have IP b=
locks
> > > > for HDMI or other types of outputs or does it provide only RGB outp=
ut to
> > > > external blocks?
> > >=20
> > > No, there's only one RGB output port, but you can connect more than o=
ne
> > > device on the RGB port (should we call it DPI port ?).
> > > Actually Atmel connected an HDMI encoder and an LCD panel connected on
> > > the same port on their dev kit.
> >=20
> > This was discussed in some other thread if I remember correctly. I still
> > think that the HLCDC node should only contain a single output, no matter
> > how many encoders or panels get connected.
> >=20
> > So the output represents the set of signals that exit the IP block, but
> > what's connected to them on the board is a board-level detail and
> > therefore should go into the board DTS.
> >=20
> > In the above case of the Atmel devkit, is there any way to control where
> > the signal goes or does it just go to both the panel and HDMI encoder at
> > the same time and it's up to the user to properly configure the output
> > in order to get either HDMI or panel to display anything?
>=20
> No there's no way to control where the signal goes.
> What you can control though, is the activation of the associated
> encoder/connectors connected on this bus (using dpms).

But the bus is really only the CRTC, so using DPMS for this is not how
it's usually done in DRM. Can't you model both outputs as separate
encoders and then attach them to the CRTC? This should work
automatically for the framebuffer console and any userspace that can
talk KMS.

Perhaps that's already what's being done and I misunderstand what you're
saying. I should go back to reviewing the DRM driver. I started this
morning, then got interrupted by other things.

Thierry

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMqaAAAoJEN0jrNd/PrOhPWcQAKI/kaqv6tRhTPQC9CCf0TGu
HY/0l5y1KDdcQxyQmaFp8NQ7/AIgrr22dCHAIou2umwySJ3FwOWzGaTvtPcoNaVw
GZRsAjKBkAgmX5uWG83m0kFszN9t7LhfbxdAcmV4blpc4egdibuAkOfdNMHSv03U
j2f7OegmHxnRGE/KEv08X1/40GE4oLWO+0/oM+mvs7Y0fP6XDvhA0dKZBYHRO/Uw
SK9AYqTbvtbWjEtWUftn/LmnB3eYI9U5+TSkNBEGV64bM3sQkn2WgTpQEMgqY6zT
MFYkmIoBLqLUhos09ZaDJDQR0lDmAXh42C5yIY5njkRRM+L7QjgazK1wKE3NmwAM
VVT/t5UnlWpse085Cu44ejsS3NxTdb1KTNRhNBrEZkWPAnErBFVXM/iwCtuBKlXN
MeHzi+AB7sGC/CzquZ1BVgFzIpqup7tgnQcccGsHwT20AnT0fWSD61fUQtJU/l2K
6UJy/RfqPSZ9fyv9AWe5IuvEP/Xck2L+zTwQETj57uVjvg4dcbdd41L+jImVcTBw
sB03Bsc0xUXZO65cjhqSTml0MPIIxS8t+b0sQUekXA4M+yJRpg/P55s6Qg6fBzX3
iixc9Qe+kQ+MgiqNstI+s0D2YdmOOTbF5RXKzH25tdx6blT1mBc4kZyBjIhBB3pB
pLsqi1M55UTvaPBXLDna
=Z/9P
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
