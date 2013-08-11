Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3HKIAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 04:00:12 -0400
Received: from mout.web.de ([212.227.15.4]:51196 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3HKH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 03:59:46 -0400
Message-ID: <5207446F.1090703@web.de>
Date: Sun, 11 Aug 2013 09:59:43 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH] trace-cmd: Report unknown VMX exit reasons with code
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="58q3bbvEswqDtfOFaAqsjCVEhxEi3u7An"
X-Provags-ID: V03:K0:GZ3S0Jn2tgbPyJKAB9SRaNJW8PJKJvrOUp8xredxmeECEzOwDp/
 Sq9XElbQd2xJinbG9CJT8FvT9QyT4R1wLkPne9Z5o1bKW6Z/DEjBoIvPoctsTiZzidOuSRx
 TuTUgnVSw2gnw6cSgTQFSVL3KCCWRkk8VRuIlc2BcV5NTjINaOa/0LYenb4dd/I/5dHPRrZ
 qQUG2jkambcjBEof5PTaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--58q3bbvEswqDtfOFaAqsjCVEhxEi3u7An
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Jan Kiszka <jan.kiszka@siemens.com>

Allows to parse the result even if the KVM plugin does not yet
understand a specific exit code.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 plugin_kvm.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/plugin_kvm.c b/plugin_kvm.c
index 8a25cf1..59443e5 100644
--- a/plugin_kvm.c
+++ b/plugin_kvm.c
@@ -240,9 +240,8 @@ static const char *find_exit_reason(unsigned isa, int=
 val)
 	for (i =3D 0; strings[i].val >=3D 0; i++)
 		if (strings[i].val =3D=3D val)
 			break;
-	if (strings[i].str)
-		return strings[i].str;
-	return "UNKNOWN";
+
+	return strings[i].str;
 }
=20
 static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *r=
ecord,
@@ -251,6 +250,7 @@ static int kvm_exit_handler(struct trace_seq *s, stru=
ct pevent_record *record,
 	unsigned long long isa;
 	unsigned long long val;
 	unsigned long long info1 =3D 0, info2 =3D 0;
+	const char *reason;
=20
 	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < 0)=

 		return -1;
@@ -258,7 +258,11 @@ static int kvm_exit_handler(struct trace_seq *s, str=
uct pevent_record *record,
 	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
 		isa =3D 1;
=20
-	trace_seq_printf(s, "reason %s", find_exit_reason(isa, val));
+	reason =3D find_exit_reason(isa, val);
+	if (reason)
+		trace_seq_printf(s, "reason %s", reason);
+	else
+		trace_seq_printf(s, "reason UNKNOWN (%llu)", val);
=20
 	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);=

=20
--=20
1.7.3.4


--58q3bbvEswqDtfOFaAqsjCVEhxEi3u7An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIHRG8ACgkQitSsb3rl5xS0vwCeJa9CrNKwZgpDZRVUnGZuAKWH
Q7wAnAj5WSoLeeGml3VMQ9GHaDdvPM4t
=AQhH
-----END PGP SIGNATURE-----

--58q3bbvEswqDtfOFaAqsjCVEhxEi3u7An--
