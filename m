Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3JDN4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:56:23 -0400
Received: from mout.web.de ([212.227.17.11]:56057 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab3JDN4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:56:21 -0400
Message-ID: <524EC54D.5060503@web.de>
Date: Fri, 04 Oct 2013 15:40:29 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Report unknown VMX exit reasons with code
References: <5207446F.1090703@web.de>
In-Reply-To: <5207446F.1090703@web.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eOl01GiT5mH8U3FmODS770aGIIvNmKXe7"
X-Provags-ID: V03:K0:NMhWK5gR47wiiJ8b6gAOl9xQLckB8ku8ZD9DBUUJnkGrpZYksTq
 uGMypFmKQDjn/5u6G2rB0mB9HWUa8sVVIjtG4x59PBVBMV90JGp+ky4wvDjWyqGUFcYjVuX
 DmEnuF+WLTqm/1J8hzX33fq6+vVeojzl80FggQomzt7i5i68fWCKeI9CALBTmpdoYkBSte1
 FdfgLrsPRj1l7LjMtlC/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eOl01GiT5mH8U3FmODS770aGIIvNmKXe7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-08-11 09:59, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>=20
> Allows to parse the result even if the KVM plugin does not yet
> understand a specific exit code.
>=20
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  plugin_kvm.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/plugin_kvm.c b/plugin_kvm.c
> index 8a25cf1..59443e5 100644
> --- a/plugin_kvm.c
> +++ b/plugin_kvm.c
> @@ -240,9 +240,8 @@ static const char *find_exit_reason(unsigned isa, i=
nt val)
>  	for (i =3D 0; strings[i].val >=3D 0; i++)
>  		if (strings[i].val =3D=3D val)
>  			break;
> -	if (strings[i].str)
> -		return strings[i].str;
> -	return "UNKNOWN";
> +
> +	return strings[i].str;
>  }
> =20
>  static int kvm_exit_handler(struct trace_seq *s, struct pevent_record =
*record,
> @@ -251,6 +250,7 @@ static int kvm_exit_handler(struct trace_seq *s, st=
ruct pevent_record *record,
>  	unsigned long long isa;
>  	unsigned long long val;
>  	unsigned long long info1 =3D 0, info2 =3D 0;
> +	const char *reason;
> =20
>  	if (pevent_get_field_val(s, event, "exit_reason", record, &val, 1) < =
0)
>  		return -1;
> @@ -258,7 +258,11 @@ static int kvm_exit_handler(struct trace_seq *s, s=
truct pevent_record *record,
>  	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
>  		isa =3D 1;
> =20
> -	trace_seq_printf(s, "reason %s", find_exit_reason(isa, val));
> +	reason =3D find_exit_reason(isa, val);
> +	if (reason)
> +		trace_seq_printf(s, "reason %s", reason);
> +	else
> +		trace_seq_printf(s, "reason UNKNOWN (%llu)", val);
> =20
>  	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1=
);
> =20
>=20

Ping. While my other patch of that time was merged, this one didn't make
it yet. Any open issues?

Jan


--eOl01GiT5mH8U3FmODS770aGIIvNmKXe7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJOxVAACgkQitSsb3rl5xTLsgCfblACSBcLur5PezRU9Qe5J8J5
G4kAn2jJuuCAx6xHe3p3NmiO/P661m1B
=VjCs
-----END PGP SIGNATURE-----

--eOl01GiT5mH8U3FmODS770aGIIvNmKXe7--
