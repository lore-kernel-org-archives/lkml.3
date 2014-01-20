Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaATQqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:46:51 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51549 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaATQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:46:48 -0500
Message-ID: <52DD52EB.3000308@gmail.com>
Date: Mon, 20 Jan 2014 10:46:35 -0600
From: Souvik Banerjee <souvik1997@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
References: <52DD4096.6020408@gmail.com> <20140120153105.GA1650@srcf.ucam.org> <52DD492F.1060208@gmail.com> <20140120161132.GC3844@srcf.ucam.org> <52DD4F74.4000807@gmail.com> <20140120163701.GA6312@srcf.ucam.org>
In-Reply-To: <20140120163701.GA6312@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fsanmj50i17LUlb2FibCg7XF15x7sCFNT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fsanmj50i17LUlb2FibCg7XF15x7sCFNT
Content-Type: multipart/mixed;
 boundary="------------060101040908040200010408"

This is a multi-part message in MIME format.
--------------060101040908040200010408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I see. Here's the patch with KE_IGNORE instead of KE_KEY. Does it look ok=
?


This key is reported by the keyboard controller but also generates WMI
events. By adding it to the legacy keymap the WMI messages can be
silenced.
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c
b/drivers/platform/x86/dell-wmi.c
index 60e0900..72f6cc8 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -92,6 +92,9 @@ static const struct key_entry dell_wmi_legacy_keymap[]
__initconst =3D {
        { KE_IGNORE, 0xe025, { KEY_RESERVED } },
        { KE_IGNORE, 0xe026, { KEY_RESERVED } },

+       /* For laptops like the Dell Inspiron N4110 with a monitor hotkey=
 */
+       { KE_IGNORE, 0xe027, { KEY_SWITCHVIDEOMODE } },
+
        { KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
        { KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
        { KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
--=20
1.8.5.3



On 01/20/2014 10:37 AM, Matthew Garrett wrote:
> On Mon, Jan 20, 2014 at 10:31:48AM -0600, Souvik Banerjee wrote:
>> I used KE_KEY instead of KE_IGNORE. Should it be changed to KE_IGNORE?=

>> On my kernel build with KE_KEY everything works as expected, but I hav=
e
>> not tried it with KE_IGNORE.
>=20
> KE_KEY means that dell-wmi will report the key. If it's also being=20
> reported via the keyboard controller then it should be KE_IGNORE=20
> instead.
>=20

--------------060101040908040200010408
Content-Type: text/x-patch;
 name="0001-dell-wmi-Add-KEY_SWITCHVIDEOMODE-for-Dell-N4110.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-dell-wmi-Add-KEY_SWITCHVIDEOMODE-for-Dell-N4110.patch"

=46rom 66440f78e9989d759be4dd550f76179d8df64083 Mon Sep 17 00:00:00 2001
From: Souvik Banerjee <souvik1997@gmail.com>
Date: Mon, 20 Jan 2014 09:10:29 -0600
Subject: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.

This key is reported by the keyboard controller but also generates WMI
events. By adding it to the legacy keymap the WMI messages can be
silenced.
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-=
wmi.c
index 60e0900..72f6cc8 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -92,6 +92,9 @@ static const struct key_entry dell_wmi_legacy_keymap[] =
__initconst =3D {
 	{ KE_IGNORE, 0xe025, { KEY_RESERVED } },
 	{ KE_IGNORE, 0xe026, { KEY_RESERVED } },
=20
+	/* For laptops like the Dell Inspiron N4110 with a monitor hotkey */
+	{ KE_IGNORE, 0xe027, { KEY_SWITCHVIDEOMODE } },
+
 	{ KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
 	{ KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
 	{ KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
--=20
1.8.5.3


--------------060101040908040200010408--

--fsanmj50i17LUlb2FibCg7XF15x7sCFNT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS3VLzAAoJEDYrZuXu8ZIM4Y4QAJa4gyRqCcq1Vzjf4khdcGK1
c/fTq30LZcWs6YT5OG49zcKdf/qEFNFeuJmzT9IGvvJkdHIPEiBRQC3Px7mAaC5R
Fk1EdvyyzaEtJkeoPmqqhzJlQxKnwNF65G7OUzm594p2ZjyUOxFSHN3Cw/5c+8Vq
jCjNk189pzSupKdB90kbj0yyVedNxnEtZ+iRDlFIySP1XReT3gfwr/ocSu+m8EFu
uchW8yDjMRgIG8rOK1RCLYoAbsgECAKN3ts+yrVQHc9KZdtqlAXNt1qDE4LJ4C9l
xrJ5GeVpA0jLnDer7mHJHW8RG2VH78bws80ZGNQ+YxSjwtRqZHBEcpVw8nLSUzsd
DwYzomr7F4VRw9l9sBDA433CWobxLS2nZQGn0oEyPYTRrrtu5c+PnFiMIY8gDQkq
x8msC9ACle7CZebpLamwYAvuCFauVS7W7MeCiQz0SE6xm+uStdDTKHSuk+KUu8zD
eR2DlZzqcy/nESdQKdslANEgp03IfjIQcB+K9/Cq3+Ibt1tKB/Me6rRexyqy2WD+
JWq6X67EJ3OaCzIx1CUhxuY5p9EQ5Ie362WYzfXuqKM+gPiGSARr+YD6+dbLGNMU
vBTfEpK8lcqoMbKZclqkrFwlik6yFILbGywU6TpkV6v0z9zKCY1lDJ55rtPBDdis
ITWISRTrr4d3pOZ9X5dI
=mwK0
-----END PGP SIGNATURE-----

--fsanmj50i17LUlb2FibCg7XF15x7sCFNT--
