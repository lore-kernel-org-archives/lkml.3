Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3BEVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:37:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56292 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab3BEVh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:37:29 -0500
Date: Tue, 5 Feb 2013 23:37:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-usb@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130205213710.GA3739@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <20130121184138.GB10106@arwen.pp.htv.fi>
 <20130121185716.GA26754@kroah.com>
 <201302051627.18337.arnd@arndb.de>
 <20130205170027.GB1081@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20130205170027.GB1081@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 05, 2013 at 09:00:27AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 05, 2013 at 04:27:18PM +0000, Arnd Bergmann wrote:
> > On Monday 21 January 2013, Greg Kroah-Hartman wrote:
> > > On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> > > > > Both the fsl_mxc gadget and the imx_udc gadget drivers fail to bu=
ild
> > > > > without the mach/hardware.h file that is not available when build=
ing
> > > > > for multiplatform. Let's disable these drivers for v3.8 in combin=
ation
> > > > > with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unl=
ess
> > > > > someone has an better solution.
> > > > >=20
> > > > > Without this patch, building allyesconfig results in:
> > > > >=20
> > > > > drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardwar=
e.h: No such file or directory
> > > > >=20
> > > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > > Cc: Felipe Balbi <balbi@ti.com>
> > > > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Cc: linux-usb@vger.kernel.org
> > > >=20
> > > > NAK, I prefer to see a real fix for the problem (which in fact is
> > > > already in my fixes branch).
> > >=20
> > > I'll pull that branch now, sorry for the delay.
> >=20
> > Apparently it hasn't made it into the upstream kernel yet, and it also =
doesn't
> > seem to be in linux-next. Maybe this got lost while you were travelling?
>=20
> Hm, no, I thought I got Felipe's fixes branch up into Linus's tree
> already.  Felipe, did I miss something from you?  If so, please resend
> or let me know, as I don't have anything pending on my side.

I don't have anything pending in my fixes branch:

$ git log fixes ^linus/master

$ git show-branch linus/master
[linus/master] Merge branch 'fix-max-write' of git://git.kernel.org/pub/scm=
/linux/kernel/git/teigland/linux-dlm

It's building find for me:

$ crossmake drivers/usb/gadget/fsl_udc_core.o \
	drivers/usb/gadget/fsl_mxc_udc.o > /dev/null

(crossmake is an alias to make ARCH=3Darm)

Arnd, are you maybe missing a merge of v3.8-rc6 ?

I can see that imx_udc.c is broken still, but there are no maintainers
for that driver. I'm adding Sascha to Cc list, maybe he knows someone
who can help, but if this driver isn't fixed in 2 merge windows, I will
schedule for removal from tree and someone else will have to
re-introduce it later without all the bogus includes.

---- build breaks ---

sound/soc/fsl/imx-pcm.c: In function 'snd_imx_pcm_mmap':
sound/soc/fsl/imx-pcm.c:28:2: error: 'KBUILD_MODNAME' undeclared (first use=
 in this function)
sound/soc/fsl/imx-pcm.c:28:2: note: each undeclared identifier is
reported only once for each function it appears in
make[3]: *** [sound/soc/fsl/imx-pcm.o] Error 1

drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
drivers/video/omap2/dss/dss.c:572:20: error:
'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier
is reported only once for each function it appears in
make[4]: *** [drivers/video/omap2/dss/dss.o] Error 1

--=20
balbi

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREXuGAAoJEIaOsuA1yqREjsYP/3o3ETdLfX+XyV+Kydflh4Iz
dChzgfNez/PKx/YzZ7rFqWmNjm2COCdpIREyfXbkuiQaNPzOh8vuZCYPgrsFacKs
c0bc2uGVMIJ+rnouc4Y/XLOfybAM/WvhkRBXVd9+30PFtre8kHPdEz6ASv0PAOmp
ezobPgBFDULDcSVTwDGSVuRn/TGvjiXv1+6jQxdf0gfyhBxmU2rO7ATN5/YOcULi
LeV/UFdKweB6LT/1N39n/YIU/2+/MtoOhnNidMHQO/UpMT8m/ywgcI1Sh2WR/Jfe
Sf6ZxGNkYW3uYtc1XCd2B09zJTxXwhfWVnp/Xlbo8mn5oHu8xCQTxKe66x9aEvsM
1Fav25VdI2Bccgrj583XaBAYGubvJ8XOExTJEt+XCd3CfGkkOdHj2jgCWq1kb+z4
ZPDdAD0935YuLZbItAKInC8a043FQ3AluWUm0rNmE700bnG91QXF51bM/tcO8IYo
tJu57nxyvarUyhgIhyl2CpmIfi7A69obpQBr3EDKipR+k4CVD6xPniz6HKPoOzn4
U40EN0aeT6qOZ1nB4c8N4/zmmzhdptIf1AJ4wRQmVw1dPhFW55nLmbF7vw4pIA1a
/N67d7eIwj0SDELN2pZ6tCLGO4f2WfABJU9QrX4g90LAbb9sprA1GfmnamFOyzJD
8JhDDWwBGqfxJ1LEqo5U
=ixSx
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
