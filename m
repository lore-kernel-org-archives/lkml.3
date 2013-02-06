Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3BFHGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 02:06:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38298 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3BFHGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 02:06:48 -0500
Date: Wed, 6 Feb 2013 09:06:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-usb@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130206070626.GA22064@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <20130205170027.GB1081@kroah.com>
 <20130205213710.GA3739@arwen.pp.htv.fi>
 <201302052254.00426.arnd@arndb.de>
 <20130206015511.GC1073@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20130206015511.GC1073@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 05:55:11PM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 05, 2013 at 10:54:00PM +0000, Arnd Bergmann wrote:
> > On Tuesday 05 February 2013, Felipe Balbi wrote:
> > > [linus/master] Merge branch 'fix-max-write' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/teigland/linux-dlm
> > >=20
> > > It's building find for me:
> > >=20
> > > $ crossmake drivers/usb/gadget/fsl_udc_core.o \
> > >         drivers/usb/gadget/fsl_mxc_udc.o > /dev/null
> > >=20
> > > (crossmake is an alias to make ARCH=3Darm)
> > >=20
> > > Arnd, are you maybe missing a merge of v3.8-rc6 ?
> > >
> > > I can see that imx_udc.c is broken still, but there are no maintainers
> > > for that driver. I'm adding Sascha to Cc list, maybe he knows someone
> > > who can help, but if this driver isn't fixed in 2 merge windows, I wi=
ll
> > > schedule for removal from tree and someone else will have to
> > > re-introduce it later without all the bogus includes.
> >=20
> > Ah, I see what happened now: I submitted a patch that lumped together
> > two patches, disabling both fsl_mxc_udc and imx_udc. You already had
> > a fix for the first one, so I dropped my patch, but now I see the
> > build error for the second one that my patch was avoiding.
> >=20
> > The last patch to imx_udc that seems to have seen more than just
> > build testing was probably "USB: gadget: imx_udc: don't queue more
> > data when zlp is to be sent", while fsl_mxc_udc looks actively
> > maintained. It's not completely clear to me whether these
> > are actually two drivers for the same hardware, of whether
> > imx_udc is the i.mx1 variant and fsl_mxc_udc is the i.mx2 variant.
> >=20
> > What I can say is that no platform in the kernel currently defines
> > an "imx_udc" platform_device, so it is certainly unused, and has
> > been since at least e08300043e in 2010.
> >=20
> > I would suggest that we mark the imx_udc driver as 'depends on
> > BROKEN' right away, since no in-tree user needs it, and any
> > out of tree user is already broken in 3.8. I also wouldn't
> > mind removing the driver unless the imx maintainers have
> > a plan for it.
>=20
> Sure, someone just send me a patch for that and I'll be glad to mark it
> BROKEN.

coming in a minute

--=20
balbi

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREgDyAAoJEIaOsuA1yqREYNAQAIEerWoIOmZ7YuqcF0S/m63u
3qDyi9M2mgp9TnCHys48eSuDyYRiRgh5W/L3VA3FytGS62WST4bZJD5sy/CKTn6Q
zx/Vp6N0MH58RBM/hUp2fhFgohsVD+zAYyWcfZJ2g8HiFP4RXUJASWSfzMxaM2SC
I9OuCPM4q7hIIdxOSrvnJeYh/GMVro7SuWAQE3pIDYUxmY60eHYiXhlKzDsz0ajy
2x0AZv+Eqj3BwixBSaVsVzMIl3B1/33joDPBC+7QtTSvYq6hCwcYshjN9Sm22Cpg
MeQMXfWAs73JwIgocTmDlZ78NrLzI2NfsnZdTFUvPJv2QuBrgvDwfcr4EHkbMMKA
0lX2hBnlJs6CgWruKQVWmrf7iSJC5F1enev+To+6aU3UFtgUH8WmH8okyQDnDPQi
fi1m5epyCd8kkr1iUhCzEE2UWosI1OhnRp7AV7roXQyRzpIad+0C9T2YkXRV5t1a
3KdwQLHosaBvl83trrC2YXNS5vKox5MQ52nzauKdhGFNk4GIcfYTvScRCuvssuIn
blCads8yFTUNuFmB7Zw3+SuI6B9Ro6eKziICrlInqbtBy067SisxM6l012ircvAC
3P2jHcCninULlJOjZCBBW99eOnYJ8sCbuAjaOS9KM8Qrlf1G058sG2llWCT604fE
kBiAQdKjWUY+ueDAUaP4
=IIaW
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
