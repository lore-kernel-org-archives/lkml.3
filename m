Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbaEMNRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:17:34 -0400
Received: from mx1.emlix.com ([88.198.240.195]:39145 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164AbaEMNRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:17:31 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 09:17:31 EDT
From: Rolf Eike Beer <eb@emlix.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
Date: Tue, 13 May 2014 15:09:05 +0200
Message-ID: <3275231.ERSr3mUlis@devpool02>
Organization: Emlix GmbH
User-Agent: KMail/4.13 (Linux/3.14.3-1.g2a280a3-desktop; KDE/4.13.0; x86_64; ; )
In-Reply-To: <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11294449.9SqiSqRQko"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart11294449.9SqiSqRQko
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Montag, 28. April 2014, 22:27:39 schrieb Lan Tianyu:
> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) ope=
ration
> region. It allows ACPI aml code able to access such kind of devices t=
o
> implement some ACPI standard method.
>=20
> On the Asus T100TA, Bios use GenericSerialBus operation region to acc=
ess
> i2c device to get battery info. So battery function depends on the I2=
C
> operation region support. Here is the bug link.
> https://bugzilla.kernel.org/show_bug.cgi?id=3D69011

Hi all,

I have tested this series and got some errors, but no additional functi=
onality:

[    0.607442] ACPI Error: Error attaching device[f60238a0] data
[    0.607460]  (20140214/bus-143)
[    0.607708] ACPI Error: Error attaching device[f60238a0] data
[    0.607724]  (20140214/bus-143)
[    0.607987] ACPI Error: Error attaching device[f60238a0] data
[    0.608003]  (20140214/bus-143)
[    0.608251] ACPI Error: Error attaching device[f60238a0] data
[    0.608267]  (20140214/bus-143)
[    0.608515] ACPI Error: Error attaching device[f60238a0] data
[    0.608531]  (20140214/bus-143)

A bit more output, e.g. the error code if such is present or the device=
 path,
could probably help when identifyint the device in question.

Also this still looks incomplete, as on other places one still gets tho=
se
warnings:

[    0.314944] pnp 00:08: Plug and Play ACPI device, IDs INT33fc (activ=
e)
[    0.316122] pnp 00:09: unknown resource type 19 in _CRS
[    0.316136] pnp 00:09: can't evaluate _CRS: 1

I don't know if looking on them at this place has any value, maybe some=
thing
like this is correct?

commit 52e2822c4c8b09180e5eb3dd94e4e9aea0d25eff
Author: Rolf Eike Beer <eb@emlix.com>
Date:   Tue Feb 18 11:11:10 2014 +0100

    ACPI: ignore GPIO and SERIAL_BUS resources in PNP init code

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rspar=
ser.c
index 167f3d0..5b8459b 100644
=2D-- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -240,6 +240,8 @@ static acpi_status pnpacpi_allocated_resource(struc=
t acpi_resource *res,
                break;
=20
        case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
+       case ACPI_RESOURCE_TYPE_GPIO:
+       case ACPI_RESOURCE_TYPE_SERIAL_BUS:
                break;
=20
        default:

Greetings,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Bertha-von-Suttner-Str. 9, 37085 G=F6ttingen, Germany
Sitz der Gesellschaft: G=F6ttingen, Amtsgericht G=F6ttingen HR B 3160
Gesch=E4ftsf=FChrung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source

--nextPart11294449.9SqiSqRQko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iJwEAAECAAYFAlNyGXoACgkQq+RR+17trfxq4wP/bCGDCYJ/raM0eIWhU2/BQnWd
pHEzKQ7+VFHU1zgPbtmpCwoJbf31dQJrmXE/Mwa8aGxgGWMVd5UpVHDXsbC5uFbj
dRE1iHqT+dNdqQkk5Ljj91EF0UWeJeB9UGPY3V6I+bNiEtQwCTkhKd/2xriVCGjt
kQwNnyDHrtPnmVaCtAs=
=1A+f
-----END PGP SIGNATURE-----

--nextPart11294449.9SqiSqRQko--

