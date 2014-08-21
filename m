Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaHUOAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:00:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56939 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaHUOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:00:48 -0400
Date: Thu, 21 Aug 2014 09:00:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: Daniel Mack <daniel@zonque.org>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <svemula@xilinx.com>, <anirudh@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v4 2/2] usb: gadget: Add xilinx usb2 device support
Message-ID: <20140821140040.GE9608@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406020130-20467-1-git-send-email-sbhatta@xilinx.com>
 <31c3ad1a-370a-4d0d-b392-8e7bb292f6aa@BN1AFFO11FD050.protection.gbl>
 <53F31F52.8060904@zonque.org>
 <CALHRZur5BC8Q2WFghU8jAtXzt1=tm=8swxp2xEz3MV4z5CCE9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <CALHRZur5BC8Q2WFghU8jAtXzt1=tm=8swxp2xEz3MV4z5CCE9A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 12:19:03PM +0530, sundeep subbaraya wrote:
> Hi Daniel,
>=20
> On Tue, Aug 19, 2014 at 3:26 PM, Daniel Mack <daniel@zonque.org> wrote:
> > Hi,
> >
> > On 07/22/2014 11:08 AM, Subbaraya Sundeep Bhatta wrote:
> >> This patch adds xilinx usb2 device driver support
> >
> > Add some more information here, please. Copying the text from the
> > Kconfig option is already a good start.
> >
> >>  drivers/usb/gadget/Kconfig      |   14 +
> >>  drivers/usb/gadget/Makefile     |    1 +
> >>  drivers/usb/gadget/udc-xilinx.c | 2261 ++++++++++++++++++++++++++++++=
+++++++++
> >>  3 files changed, 2276 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/usb/gadget/udc-xilinx.c
> >
> > As your driver has a DT binding, you have to describe it in
> > Documentation/devicetree/bindings.
> >
> >> --- a/drivers/usb/gadget/Kconfig
> >> +++ b/drivers/usb/gadget/Kconfig
> >> @@ -459,6 +459,20 @@ config USB_EG20T
> >>         ML7213/ML7831 is companion chip for Intel Atom E6xx series.
> >>         ML7213/ML7831 is completely compatible for Intel EG20T PCH.
> >>
> >> +config USB_GADGET_XILINX
> >> +     tristate "Xilinx USB Driver"
> >> +     depends on COMPILE_TEST
> >
> > Why would you depend on that?
>=20
> Felipe asked to make this since this is USB soft IP driver and its
> dependencies have tendency to grow.

that's not exactly what I asked :-) Usually you only add COMPILE_TEST
when you have an ARCH dependency. So something like:

	depends on ARCH_ARM || COMPILE_TEST

would make it clear that this driver is only available on ARM, but when
doing my build tests, I'd still be able to compile it on x86.

> > Also, your code uses device tree functions unconditionally, which is
> > fine, but it must hence depend on 'OF'.
>=20
> Ok will add OF along with COMPILE_TEST

so this would be:

	depends on OF || COMPILE_TEST

--=20
balbi

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9fuIAAoJEIaOsuA1yqREQIwP/juZaobbwYMGtM6taA5Vyazv
KHjPzzxXb6YiA+oSFNOU7AkLS9dpt9dzsKWXFIS+AM/+oacI1C0VNOf27swJvy+4
hRgm0KLL3M2QjMcwDhMnCJxOvdVJY1xxmhdYhRTAMTwPPiT/4pfPIst/vgoOyx30
iWiCAjlihNrrlU6IEIeDjT7QY0mKvcoZuKe7ny7/4LnEmusZJ+Lzm3RgbrSKIp0B
mZrO2v26HjcS/lq/e+iWcfkftwXHeb1Zrg7Cro4jd/UDIG6C7Bpa4eP3UXcA7Jhn
tOzPDlT1xKtFjTJel/sJSFJ3a0vUyD4TBzgQvvmM6lyXHlU+1h1kkmspEPx9kQbD
2vxREjV3J003JNQSgzaoFXt583QUNMwfuCmXolAycBfxmfl7RK1C1Yap5+V2/Q2A
I9F6lH/r6eVLoRCa8YPuFkpC8faAGIFa6Z36+iE4xWt9ZeGwx2fpYJKFPA5AHQee
nDVmALJ2AQXiqpHb+w6Tc160Jr6Ev+6FZ783VfAzwguCheaAcDq2/M4PvyF2PPVn
y4AogoWhEvbhC50BSpGTKQ8so1+2tUUE9yjqDkCFygE+Ak50EC7mcNlYaL3gWTPM
EpT9Q/Ret0YkecxHHJpOO1VdL13OlCgDTOiZGsYVREbpwQM0Mbliag+MohZHIxUp
VOOW9pp8r4P3fRU+z189
=YfJK
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
