Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaLBQa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:30:29 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58901 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaLBQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:30:27 -0500
Content-Type: multipart/signed; boundary="Apple-Mail=_CEC97425-3CC5-47A1-9E48-D21EC8561FFC"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Determination for the number of named function parameters (with SmPL)
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <547C4D11.1050206@users.sourceforge.net>
Date: Tue, 2 Dec 2014 08:30:23 -0800
Cc: kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        LKML <linux-kernel@vger.kernel.org>
Message-Id: <8DDAD79C-96D4-43BA-BC3F-F9EE237D2C60@gmail.com>
References: <547C4D11.1050206@users.sourceforge.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_CEC97425-3CC5-47A1-9E48-D21EC8561FFC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 1, 2014, at 3:12 AM, SF Markus Elfring =
<elfring@users.sourceforge.net> wrote:

> Hello,
>=20
> Would you like to know how many named function parameters are used in =
the source files?
>=20
> How do you think about to try the following semantic query approach =
out a bit more?
>=20
> @initialize:python@
> @@
> import sys
> import sqlite3 as SQLite
> connection =3D SQLite.connect(":memory:")
> c =3D connection.cursor()
> c.execute("""create table numbers (number integer)""")
> delimiter =3D "|"
>=20
> def store_number(count):
>    """Add an integer to an internal list."""
>    c.execute("""insert into numbers (number) values (?)""",
>              (count, )
>             )
>=20
> @counting_parameters@
> identifier work;
> parameter list[number] pl;
> type return_type;
> @@
> return_type work(pl)
> {
>  ...
> }
>=20
> @script:python collection@
> count << counting_parameters.number;
> @@
> store_number(count)
>=20
> @finalize:python@
> @@
> c.execute("""select count(*) nr from numbers""")
> result =3D c.fetchone()
>=20
> if result[0] > 0:
>   c.execute("""create index x on numbers (number)""")
>   c.execute("select number, count(*) nr from numbers group by number")
>   sys.stdout.write(delimiter.join( ("number", "counter") ))
>   sys.stdout.write("\r\n")
>   for result in c:
>      sys.stdout.write(delimiter.join((str(result[0]),
>                                       str(result[1])
>                                      )))
>      sys.stdout.write("\r\n")
> else:
>   sys.stderr.write("No result for this analysis!\n")
>=20
> connection.close()
>=20
>=20
>=20
> elfring@Sonne:~/Projekte/Coccinelle/Probe> XX=3D$(date) && spatch.opt =
-timeout 12 -sp-file list_parameter_numbers1.cocci -dir =
/usr/src/linux-stable > list_parameter_numbers1.txt 2> =
list_parameter_numbers1-errors.txt ; YY=3D$(date) && echo "$XX * $YY"
> ...
> elfring@Sonne:~/Projekte/Coccinelle/Probe> cat =
list_parameter_numbers1.txt
> number|counter
> 0|29

I think the results are dubious. Only 29 functions with no parameters? =
That can't be right.

> 1|18261
> 2|15374
> 3|12237
> 4|8159
> 5|4339
> 6|2701
> 7|1183
> 8|518
> 9|260
> 10|146
> 11|83
> 12|42
> 13|21
> 14|9
> 15|7
> 16|2
> 17|4
> 18|1
> 21|1
> 22|1
>=20
>=20
> Do you find such an analysis result from the source files for Linux =
3.17.4
> interesting for further considerations?
>=20
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_CEC97425-3CC5-47A1-9E48-D21EC8561FFC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUfekfAAoJEDwO/+eO4+5u3+UP/3LX2yXAwM5K2LX2Ue3HXy79
k637Oh5Auvat5AbMqBRzXsTU1/iqjbI8p43lI6c4acabXmIXk+1nZMa00MnOB4oK
WK4G4pZgYwi9VJLRtDuV2HedU6VhPgUW3d0O3GnVq+MNJH47qksWDYf4cdijggjO
NtFJ3+u0p5npu7LPwnNnQF+fYPFIxXuMAviHZGS34TCf7HhyFcOLYiasqAGX2m/B
xwxb1VqP4XdCXJ6WMlsXYS72WV5OoI6HabkeC1YCaiFIII4A1E1nTYFALjUh+GBO
bgeiJLC/JXznDFS5xKJSGop5KtiJLN2A/LGSkhlsPKfsraYycgxXoMBxKOn4RDk3
a39RxU0d7KWjTYyBasqjo1eZoYy7rRnUipjb/HXk50Zr0paCI1cW6VOphfsgnf4F
0zrssqX/ujcW8ViHjAukuT5iGfuFWbg1Z7KdTaAamPCmSEEafFyJbTYC9zd14Ap/
taQeze+OU3Rgscpu+ewN+EI6A2ibkxyhn6VpdxbwmSy6f1XAqRck7IJ4fULC5EMX
WXlXsRbzFfqmo5WPnDsrakuiHJD4OekDlE150REPcbVDzYkqiT5qimGU2soyKiMO
z6h7OgG16owf38yreZSQATdQP20cZGMe+v3DzftHbTGhnXWUIycZ246m7XS9aqAk
7MkSNic2Mgc8TvKRX3Hn
=LjF8
-----END PGP SIGNATURE-----

--Apple-Mail=_CEC97425-3CC5-47A1-9E48-D21EC8561FFC--
