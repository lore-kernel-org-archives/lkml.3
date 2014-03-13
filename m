Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaCMVIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:08:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58195 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752823AbaCMVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:08:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: next-20140312 - build error in drivers/acpi/sleep.c
Date: Thu, 13 Mar 2014 22:23:51 +0100
Message-ID: <1431943.FB4azhDoEG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <22429.1394736511@turing-police.cc.vt.edu>
References: <22429.1394736511@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart92991788.Aykl3nDkE4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart92991788.Aykl3nDkE4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, March 13, 2014 02:48:31 PM Valdis Kletnieks wrote:
> Seen in the most recent linux-next with a CONFIG_SUSPEND=3Dn .config:=

>=20
>   CC      drivers/acpi/sleep.o
> drivers/acpi/sleep.c: In function 'acpi_sleep_init':
> drivers/acpi/sleep.c:808:2: error: implicit declaration of function '=
acpi_sleep_state_supported' [-Werror=3Dimplicit-function-declaration]
>   if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
>   ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/acpi/sleep.o] Error 1
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2
>=20
> Function is defined inside a #ifdef CONFIG_SUSPEND, but used outside =
of
> one in acpi_sleep_init().

This isn't caught by the build test robot.  Care to submit that .config=
 to
Fengguang so that you don't have to report such failures again?

> git blame points at commit eaa54ccbc:
>=20
> commit eaa54ccbcf81de987e6978ad457cc9e425b7a8db
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Mar 11 14:08:58 2014 +0100
>=20
>     ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep sta=
tes
>=20
>     If the HW Reduced ACPI mode bit is set in the FADT, ACPICA uses
>     the optional sleep control and sleep status registers for making
>     the system enter sleep states (including S5), so it is not possib=
le
>     to use system sleep states or power it off using ACPI if the HW
>     Reduced ACPI mode bit is set and those registers are not availabl=
e.
>=20
>     For this reason, add a new function, acpi_sleep_state_supported()=
,
>     checking if the HW Reduced ACPI mode bit is set and whether or no=
t
>     system sleep states are usable in that case in addition to checki=
ng
>     the return value of acpi_get_sleep_type_data() and make the ACPI
>     sleep setup routines use that function to check the availability =
of
>     system sleep states.
>=20

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart92991788.Aykl3nDkE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJTIiHtAAoJEILEb/54YlRxD+8QALU0ZihUefr5sI3FUoLke9yB
QAxXaiHLMfqkkzTNnRwbM72r5i5C74iMcBGE3TRGU4ztmYWx37u98/3cnqTGCCec
uIkK+gxPOY6TilqVyY+2egfvzQb/e38lblHlLzyl5RxiyKPNwJwGik77rPtqJVze
IozlleM3ntY3tcMSpfiXXxwIBUVu7q4Sf9P9mfjv/b87VVk8AI4RxSmsmyTxK2fZ
h0zFG5K9GfYt/OUzwfuVFE0Tr8sLwvhe0Wbsl50Cp5y2VzFhgKGaUan+0A9zK8g7
oHL7IDrYYB5Rwj51DV2BrtTxtTavlyTEmSjpjH43OQloOYrW2wPRusfgVHbmYzJj
dBVEGCl7/yKPgsNYzNRMiTwgvuLoTbaDDPxTabdfrlN0vy0MO5063WVLvhb4Yfzo
U6o9gJm4h9RNwq+9noTrpLrImkSDqbcLG6x9fyrICF7M9SwupPwzRner20C+g2N0
JFh6vso1lGrwqvi5ZTCNnA4PBHE87gBA8vnVsc0eLhc/55ntIfGU19yzFhNDOFzn
fmzUQJnrFRFWJBmfVAgbdC1D2DXp7OvpPEdMmFL8erByX0P7q4X8utEaWKwyRtTp
EjqvziR39xsqn0IXYoYrqroctOwp1JOInQK2KspEbdjLtyxmIzUCjyRuGhTAI1tk
e5B/ouhmUQrmmdM0y5A7
=UGOu
-----END PGP SIGNATURE-----

--nextPart92991788.Aykl3nDkE4--

