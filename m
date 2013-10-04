Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3JDL6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:58:45 -0400
Received: from sauhun.de ([89.238.76.85]:57604 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3JDL6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:58:43 -0400
Date: Fri, 4 Oct 2013 13:58:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c: xilinx: Use devm_* functions
Message-ID: <20131004115840.GB2994@katana>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
 <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com>
 <20131004053323.GB3194@katana>
 <524E8764.4030704@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <524E8764.4030704@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2013 at 11:16:20AM +0200, Michal Simek wrote:
> On 10/04/2013 07:33 AM, Wolfram Sang wrote:
> >=20
> >> +	i2c->base =3D devm_ioremap_resource(&pdev->dev, res);
> >> +	if (IS_ERR(i2c->base)) {
> >> +		dev_err(&pdev->dev, "Could not allocate iomem\n");
> >=20
> > devm_ioremap_resource already prints error messages.
>=20
> you are right.
>=20
> >=20
> >> +	ret =3D devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i=
2c);
> >=20
> > This is too early. Can you find out why?
>=20
> Why do you think that it is too early?

The ISR uses spinlocks which are not initialized by then.

> I am looking at origin code again and I think that the code
> is also problematic because in xiic_reinit() interrupts are enabled
> but they are requested later.
> Shouldn't be there a logic that interrupts should be enabled when
> interrupts are registered by the kernel?

First register the handler, then activate interrupts. You are right,
this needs to be fixed, too.

Regards,

   Wolfram


--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTq1wAAoJEBQN5MwUoCm2o38QAIxpECPwGQwCwb85r5tpuv2i
xfKyYHC5R87Wu4639kDiEXXhJPNY/bi3ur9K5YB4Qdewbo62MZA2aSsm3rmPnlQg
pMiuzU5EohWS6T7TriKxPi8vRQgJ+9ijQLIo3cPopnX8nuy2k7l+qk/92ZpAasOp
FMcxA0FiQLimNZW+j//jTgZckLRBLu+cCN1nzRiEfVFOHDkFJnlKA+q3eVFaBPYT
X90Q50CLl/lz0f/qDgyYz/CTN8HL1lwiZbAXdtd6NiBVk5xF7DYdoanSWI9do9m+
fgJ1YueoWK41fncGzWqnbgEcvWZDCDzRZpmeZlS2nprZMWqI+6rPVOgve5jvmgKZ
+H1o9IYU1HqECPU5Tea252Ex32+aUJor7kQdL4WZmCHZiQetccJQpMMnz8+WiLnj
S38BBQHbw/DXHdUbflQuaLZ0A6ETvlzwr+qLd3u4T8ufVOKxBFp3vVWj8Lpko4pB
gBoXHJCzI35rpjn70neD2L8nFWClM/8ktBgEMmYIPMQ9q8o+WWzzEQvr9LSJF+G3
4p82JVks9wt/Ijs2/XDKIwCVILropuGMWnoCivzdI6MOgI8Zy4DbB1XbCb9lAN8x
ANfY52Ebsh0Q4dI/e8+IXvc6FKFxtxrDX6NIbloeFaGEYUviAslIE+wLr9bPmaqo
JNGjl6V50zm5oIYr28DM
=MsVb
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
