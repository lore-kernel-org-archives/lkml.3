Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaAUV4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:56:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57770 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaAUV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:56:28 -0500
Date: Tue, 21 Jan 2014 21:56:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140121215624.GC17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140121185553.GW17314@sirena.org.uk>
 <52DED341.3030503@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jhHWkMHPE1TKsc4d"
Content-Disposition: inline
In-Reply-To: <52DED341.3030503@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jhHWkMHPE1TKsc4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 02:06:25PM -0600, Nishanth Menon wrote:

> Without this change, on DRA7 I get:
> [    0.579500] abb_mpu: 1060 <--> 1210 mV
> [    0.580321] abb_ivahd: 1055 <--> 1250 mV
> [    0.580583] ti_abb 4ae07e20.regulator-abb-dspeve: can't request
> region for resource [mem 0x4ae07e20-0x4ae07e2f]
> [    0.580610] ti_abb: probe of 4ae07e20.regulator-abb-dspeve failed
> with error -16
> [    0.581216] abb_gpu: 1090 <--> 1280 mV

OK, that's not to do with nocache, that's to do with duplicate
request_mem_region() calls.  Of course the trick here is that if the
other thing that requests the memory region doesn't do it then we have a
problem. =20

I really can't help thinking that a system controller node as the parent
is going to make things happier for devices that share this register
bank.  I guess it might be possible to also do it with single register
memory regions but I'd not be surprised if that wasn't possible and it
doesn't seem as idiomatic.

--jhHWkMHPE1TKsc4d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3u0EAAoJELSic+t+oim9x8YP/RTvB7giqkmD++TcNU5hFrxJ
hauwcIAC4HftGGR39Is/raPZOBa63ltvyhV83QGoOm156Yttr5hHaiZAVj9k3HTf
GiJHnCQ0DWcYY70mDNP1PmSoT+PmlgXGLHDQ77yubWsiBw75Ql+CHz7USlWQxQe5
vW1EchHe26JllsSVok4XsUxjEufj2s5RSigWLJ09GiMTDFQTQdsZugrbVc3rBsSi
YS8Xdh+Qkg4AGzWsn9TroV4zIs2/gf2uUMCLon8Sc0R9OBpu+6PuGI1BCUDxgKAV
wrogSPMiw2zljq5B8kyCh4jujFANSgUiSaiJv57c9dlJ25geHYzWjXW/7MRP3XJy
nwRRNMHXHn2I6r0OcBl3Vz2DRCH3//++wdcmFTaCYGIrnNI9qwB02gJkmxnKac6g
v2jru8m3ns4kUqo5QA8h/g8YjRURDoLlwVcm/qts5BsetDoTKsBgKF7D2xti8l++
tuYb/19rsl0Ntlb7ulGC0fM19ZgWH1hh2udrT6hE1Wfd/K4QLX6SKaq4rcy53Bib
HAzeaP6kp088sifGm2puSVPI73yR73NIFJuwhbAMpgmB65T087PKJDa2vsaBXevf
CmGDkE2MTithXanFxL/raesN5wj1hadfo9Cj5IhM15sZT1RT43yVojvklWlYaX/c
pKoUsrONAer4f4dH1HID
=QAu5
-----END PGP SIGNATURE-----

--jhHWkMHPE1TKsc4d--
