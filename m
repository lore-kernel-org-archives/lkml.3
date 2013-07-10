Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3GJOcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:32:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab3GJOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:32:10 -0400
Message-ID: <1373466723.24446.10.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] dmi_scan: Add comments on dmi_present() and the loop in
 dmi_scan_machine()
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Jean Delvare <jdelvare@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Jul 2013 15:32:03 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3+/4yJABrccuHl5npLuW"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3+/4yJABrccuHl5npLuW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My previous refactoring in commit 79bae42d51a5 resulted in slightly
tricky code (though I think it's more elegant).  Explain what it's
doing.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/dmi_scan.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b95159b..4fdb377 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -419,6 +419,13 @@ static void __init dmi_format_ids(char *buf, size_t le=
n)
 			    dmi_get_system_info(DMI_BIOS_DATE));
 }
=20
+/*
+ * Check for DMI/SMBIOS headers in the system firmware image.  Any
+ * SMBIOS header must start 16 bytes before the DMI header, so take a
+ * 32 byte buffer and check for DMI at offset 16 and SMBIOS at offset
+ * 0.  If the DMI header is present, set dmi_ver accordingly (SMBIOS
+ * takes precedence) and return 0.  Otherwise return 1.
+ */
 static int __init dmi_present(const u8 *buf)
 {
 	int smbios_ver;
@@ -506,6 +513,13 @@ void __init dmi_scan_machine(void)
 		if (p =3D=3D NULL)
 			goto error;
=20
+		/*
+		 * Iterate over all possible DMI header addresses q.
+		 * Maintain the 32 bytes around q in buf.  On the
+		 * first iteration, substitute zero for the
+		 * out-of-range bytes so there is no chance of falsely
+		 * detecting an SMBIOS header.
+		 */
 		memset(buf, 0, 16);
 		for (q =3D p; q < p + 0x10000; q +=3D 16) {
 			memcpy_fromio(buf + 16, q, 16);


--=-3+/4yJABrccuHl5npLuW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUd1wY+e/yOyVhhEJAQpazxAAr/c9irAQguOseBQMVOUHXbGYMyHMq/SA
sjJmpbMuWzFQVlTeqiRe6llX87+XMWzxXa4lXQubLTrWj2lcwJ2vVA2rUPSab1FW
EDY7rulLxBjkPWT2ZuJiWkJziJ4eyaorAyy3XwKAXmrdXBVgwU4rqPa2uC5Xjx+f
v/fwtOZUzJKf+0d5zrCU5ozRE9c3R7k5/glKiCPpGKe59c/L5Kiane9kPNrUxgii
Zp8WZgM6kKesfchAbp3GTnY4O0rR7mgxiyXR5/6tIh5OMuXNa2AGXg1t1LW6no+R
Tzib5WazbR2I03lIgOP3wpzZqKxjqE0phpf8o8/jk6TlcjcteAK6GJXq99oJiwS/
S+wRTknL4X8hTLcXHzRhp4z0ZiGvbQ6FqikHPvZBNXCe7UqKlpi439rNT3LxtxHa
Pe4BO/APcJ+eJoniGSCnZeub9TdP8biDBh57Ucj4Q0owuI/35DxyrTENSnmoreEH
szYwPRF9eCovK1O4myBIma1VIueiZuAHh1TdtOYd/M/irmSqk6vDJDfW3jt9zaZu
U2tgSiZCZTDRQSYQAG2+UFsVUX4KYLrI1NPqYxiK82ZZPxyd75o81xX98Gbg6lYn
rlfcKkduTvPnQ4r2g6iVVGWJ0mBTZf592lI7yQZA+ZNPWVIyKHCoHG1iKOpafm6l
k+wKAsjGuhc=
=tT7/
-----END PGP SIGNATURE-----

--=-3+/4yJABrccuHl5npLuW--
