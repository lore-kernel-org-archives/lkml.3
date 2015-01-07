Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbbAGTwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:52:49 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:13764 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbbAGTws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:52:48 -0500
Date: Wed, 7 Jan 2015 20:52:44 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] Fix error-code overwrite bug
Message-ID: <20150107195244.GB18978@salidar.dom.custoft.eu>
References: <1420394662-20011-1-git-send-email-me@mortis.eu>
 <CAHp75VeZnmsRLV6_gg9Wci03ZEJCk=dRDEkp7DsEubypVvCi3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <CAHp75VeZnmsRLV6_gg9Wci03ZEJCk=dRDEkp7DsEubypVvCi3A@mail.gmail.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 20:37:29 +0200, Andy Shevchenko wrote:
> On Sun, Jan 4, 2015 at 8:04 PM, Giel van Schijndel <me@mortis.eu> wrote:
>> Don't overwrite the returned error code with the boolean test used by
>> the if-statement (otherwise it'd be 1 or 0 always, 1 in the if-block).
>> ---
>>  drivers/mtd/nftlmount.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
>> index 51b9d6a..1cbeb6b 100644
>> --- a/drivers/mtd/nftlmount.c
>> +++ b/drivers/mtd/nftlmount.c
>> @@ -91,7 +91,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
>>                 /* To be safer with BIOS, also use erase mark as discrim=
inant */
>>                 if ((ret =3D nftl_read_oob(mtd, block * nftl->EraseSize +
>>                                          SECTORSIZE + 8, 8, &retlen,
>> -                                        (char *)&h1) < 0)) {
>> +                                        (char *)&h1)) < 0) {
>=20
> Better to move ret =3D x(); outside of condition. See here:
> http://permalink.gmane.org/gmane.linux.drivers.mtd/56922

In the sense that this bug wouldn't have occurred when using separate
assignment and condition checking you're right. It's a style issue
though, but a relevant one.

So your approach is probably better, though incomplete (like mine), just
look for the exact same (ret =3D x() < 0) pattern about 20 lines further
down the same file. (Yes that's disabled code, but I still believe the
bug should be fixed considering it's exactly the same class of bug).

So I suggest you resend that ^^ patch you link to with a fix for the
other instance of the bug fixed as well.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"If debugging is the process of removing software bugs, then programming
 must be the process of putting them in."
  -- Edsger Dijkstra

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlStjooACgkQZBYm/87l50J74ACfUQ0/RtYPgvYmRcv/0B4GO20K
+1EAnRNMWv1pnANYLj61MC1UE/oe5LTL
=ISzU
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
