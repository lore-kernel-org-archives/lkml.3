Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031684Ab3HIXmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:42:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48521 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620Ab3HIXmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:42:18 -0400
Date: Sat, 10 Aug 2013 00:42:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130809234209.GQ6427@sirena.org.uk>
References: <20130809091953.GO6427@sirena.org.uk>
 <5204B7A6.9050907@gmail.com>
 <20130809094340.GO23006@n2100.arm.linux.org.uk>
 <5204CC04.4000401@gmail.com>
 <20130809113940.GY6427@sirena.org.uk>
 <20130809130932.GS23006@n2100.arm.linux.org.uk>
 <20130809180058.GM6427@sirena.org.uk>
 <20130809182516.GT23006@n2100.arm.linux.org.uk>
 <20130809194434.GP6427@sirena.org.uk>
 <20130809203847.GU23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hqTXfEuqfuBCci/z"
Content-Disposition: inline
In-Reply-To: <20130809203847.GU23006@n2100.arm.linux.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu audio
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hqTXfEuqfuBCci/z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 09:38:47PM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 09, 2013 at 08:44:34PM +0100, Mark Brown wrote:

> > If someone wants to it should also be possible to convert the existing
> > platforms without S/PDIF support over to DT, providing you don't mind
> > changing the code once the DPCM and S/PDIF support is added and a bit of
> > thought is put into where the S/PDIF output will fit into the bindings.

> Okay, so you're thinking that the I2S output will be enabled in the
> absence of DPCM?  If so, that tells me that you don't understand my

When I say that it should be possible to convert the existing machines
over to DT I'm talking about the machines that are supported with the
drivers currently in mainline.  These machines presumably work just fine
with the existing drivers which support the I2S only subset of the
possible functionality in the hardware without using DCPM.  These are
the the machines that could have DT added now without implementing the
driver improvements to enable the extra hardware functionality.

When I say that they will need changing once DPCM and S/PDIF support is
added what I mean is that those changes to the CPU side drivers should,
as you correctly say, require all Kirkwood machine drivers to use DPCM
even if only due to the handling of simultaneous startup of the S/PDIF
and I2S interfaces.

The "you" in the above quote was intended to refer to people working on
Kirkwood in general, not you personally unless you want to.

> What this means is that the conventional setup where you have _one_ DAI
> link connecting the codec DAI to the CPU DAI won't work on Kirkwood
> anymore, because there is no way to know which of the two outputs
> should be enabled.  I avoided that in my patches, but you've objected
> to that saying that it must use DPCM.  That makes the whole of kirkwood
> entirely DPCM only, whether or not you have a single codec to connect.

Right, that's where the drivers should end up.  In terms of the device
tree I would expect that it should be the case that there are distinct
I2S and S/PDIF interfaces visible, or at least that there's some way to
identify which interface on the SoC is being referred to - this is the
thought about where the S/PDIF output will fit into the bindings that I
mentioned being required.

So long as only I2S is used in the system (or at least any S/PDIF that
is present is ignored at runtime) it should be possible to continue
using the existing driver infrastructure until S/PDIF and DPCM support
is added and then transition the existing drivers (both non-DT and any
DT ones that get added or converted) over to that as part of the
conversion.

In other words I was talking about a possible intermediate state where
people are working with the DT bindings but the driver support for
systems with S/PDIF in use is not there yet.  That's not required but it
should be possible if there's interest in progressing the DT bindings
while the driver is as it stands.

--hqTXfEuqfuBCci/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBX5OAAoJELSic+t+oim9+tkP/2rbUVERjwqCRanBLwqpQdvV
JV/UpXLa3+ujaMX9Y9ZgxY7rO/5aJmMGnHKgccuEjlo8VcEXhWXoMQ0c3cSxXvDs
UdxNeFVa+6Q3J/Yd6Dp+ETgylYizuXdajrbZ6KsFKe7NtieB2BXDTWth/+mRKW1f
zL4RrbaTuiVvKtbr3Zv5qn/d96dqrgedTIEn0XT4wNI9jJUr9br4Zq+agAON+yJf
fPaRAifhe3CxyXLHc6a/iqCd2n25HI3/rgD55SLszChbKru6VxCv1MIZijoRJWEc
rRyCwS3Q8vyaa+czjncxglA81jlMoAkHi8Y62ukE3x6oz0yUyKgugt0Cwj/JbniQ
fQPpWkKHew8NCsvpnlw8iS/WIWlCYtDDL6UK2uK1NY+Xahfer4WQ4KVYsnzjI5iQ
z2HpfSN+roYEKhoVfrnRNgcrCg4ZBxSmhxtqs3ejFGZYWnrL1zw+f4dI011uyQlK
yFIvFnHtxKNm7hwZ3w/bLWY/9VQNLtfMF6OmN1scSAbAJi5h3C5+ocVuBkT299Vs
q7BkVVz3FwM7p3haFboVdA+vY1dxVbVIB/xC9g2EmU8MhJ4KK8B6k5BiVPEC3YOB
DsaiMFjMHeSNMuRY1kjTDJSsoQ0xXopMRYy188xQl0Iexcbg/iJ+Wu1Zvp/C2oEH
+OdkSH5xJIYIJ1zoskDI
=JVZp
-----END PGP SIGNATURE-----

--hqTXfEuqfuBCci/z--
