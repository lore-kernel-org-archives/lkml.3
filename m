Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3BQF55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 00:57:57 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:63869 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3BQF54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 00:57:56 -0500
Date: Sun, 17 Feb 2013 00:57:24 -0500
From: tmhikaru@gmail.com
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dmi_scan: Fix missing check for _DMI_ signature in
 smbios_present()
Message-ID: <20130217055724.GA16842@roll>
References: <505e6314-555a-4bc6-96ef-dac735ae0bee@default>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <505e6314-555a-4bc6-96ef-dac735ae0bee@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 06:35:04PM -0800, Zhenzhong Duan wrote:
>=20
> ----- ben@decadent.org.uk wrote???
>=20
> > Commit 9f9c9cbb6057 ('drivers/firmware/dmi_scan.c: fetch dmi version
> > from SMBIOS if it exists') hoisted the check for "_DMI_" into
> > dmi_scan_machine(), which means that we don't bother to check for
> > "_DMI_" at offset 16 in an SMBIOS entry.  smbios_present() may also
> > call dmi_present() for an address where we found "_SM_", if it failed
> > further validation.
> >=20
> > Check for "_DMI_" in smbios_present() before calling dmi_present().
> >=20
> > Reported-by: Tim McGrath <tmhikaru@gmail.com>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: stable <stable@vger.kernel.org>
> > ---
> > This has a memcmp() that wasn't in the previous version, so I've not
> > included the Acked-by or Tested-by for that.
> Yes, the further "_DMI_" check is needed.
> Acked-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> >=20
> > Ben.
> >=20
> >  drivers/firmware/dmi_scan.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/firmware/dmi_scan.c
> > b/drivers/firmware/dmi_scan.c
> > index 982f1f5..a86ccff 100644
> > --- a/drivers/firmware/dmi_scan.c
> > +++ b/drivers/firmware/dmi_scan.c
> > @@ -442,7 +442,6 @@ static int __init dmi_present(const char __iomem
> > *p)
> >  static int __init smbios_present(const char __iomem *p)
> >  {
> >  	u8 buf[32];
> > -	int offset =3D 0;
> > =20
> >  	memcpy_fromio(buf, p, 32);
> >  	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
> > @@ -461,9 +460,9 @@ static int __init smbios_present(const char
> > __iomem *p)
> >  			dmi_ver =3D 0x0206;
> >  			break;
> >  		}
> > -		offset =3D 16;
> > +		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
> >  	}
> > -	return dmi_present(buf + offset);
> > +	return 1;
> >  }
> > =20
> >  void __init dmi_scan_machine(void)
I'm a little confused, do you need me to test something?
Tim McGrath

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUSBxRJEncCrqzVruAQJEJAf/W7Q+aVupi/QP4dAPP98Ih/OmHv9BA3RV
Fwd4RQbKbNe347oiYPsLA4lH3f4JsrXH8c8Mu5HlZiWWESaSoYEipf1yDlph5Jrj
WFFXMgzw/dfDwOkVZlw1IohqwYB5ls3j2P/xDxPseDIwEVnvASfx7PBRtN5XBkH8
NMl1tNDoearyC1XD+iq15MXJI5770kgjUSQWUIwVqOrXYG0AntUJNKpA5AgiWAaZ
lp5G8SU5W2ihpMFpZn2pK82PGB6tEEySIRmHUBUhH25/O73cmhAC1nXkoamrG3hI
PYJwhQOK5ENgSr379/fyxnJag66FUMjJjZeIXVB3gt6z0oopuvRcWQ==
=X1ql
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
