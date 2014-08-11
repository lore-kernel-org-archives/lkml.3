Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaHKBBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:01:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58926 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaHKBBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:01:51 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_A96589B8-D0C7-433D-9FAE-2212A365D7CF"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] misc: ti-st: st_kim.c:  Cleaning up missing null-terminate after strncpy call
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1407627938-24614-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 10 Aug 2014 18:01:48 -0700
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Message-Id: <6ACE8FE9-A4AD-4A7A-890F-49F42B81C0A4@gmail.com>
References: <1407627938-24614-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_A96589B8-D0C7-433D-9FAE-2212A365D7CF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 9, 2014, at 4:45 PM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Added a guaranteed null-terminate after call to strncpy.
>=20
> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> drivers/misc/ti-st/st_kim.c |    1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
> index 9d3dbb2..bce4468 100644
> --- a/drivers/misc/ti-st/st_kim.c
> +++ b/drivers/misc/ti-st/st_kim.c
> @@ -593,6 +593,7 @@ static ssize_t store_dev_name(struct device *dev,
> 	struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> 	pr_debug("storing dev name >%s<", buf);
> 	strncpy(kim_data->dev_name, buf, count);
> +	kim_data->dev_name[count - 1] =3D '\n';

Of course this does not add termination, but adds a newline at the end =
of the buffer? Huh?

> 	pr_debug("stored dev name >%s<", kim_data->dev_name);
> 	return count;
> }

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_A96589B8-D0C7-433D-9FAE-2212A365D7CF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT6BX8AAoJEDwO/+eO4+5uJZ0P/33V/4SxMu1OxpV0Khx3JRm/
Q2IhbruOgPDlFEayjaJKccRF8cFkT8UMsiUFWrqQbb6rcAPr61GEk3xvOunwLhOT
kftD49qfl1g0J5IkpY+dsyWGja/FZ+3ZEWBkQlt55XJzUdeBJpfSG55QfPRflODM
2erTc4miCG/L0HSQSFHt5nPZJZOKse30Q7EQVgY3TvloZPyCgecoApzIEtj1MAK1
yG2EKf7Zo1w1nCS6Ip4SnLPj80N1b9Wfpb/A5Y/tkz4HwdtVMm/hiBhm9xYM7ld5
wFPv/AkWhFHtIYDIv29AKFnZLmv6e/KKgTzCMC9/YGxvRsR5dIYqaXVgt1La5zwO
yGMjogAr4YAmuDbxW3NSNAn/IRSkRfjwWjbLD71m1xKqyKoye2f5uXUoCfcf0d4v
KJ55tj8Nt/xpy1CSn72w/NHUPijlYpnD4FHy/p9qkK3skplU4ul33bEjGrzg/zEO
K5WNU/eKCAWr6a4QVD+isDcedAgVQYFK4kWgJ4XPn/PlYfXR9Mzag7Ra0PmXqwcW
9LdkmQwNDN5sxf19/egJ4vTrLnIQR/UhTLpzzYWIymj1ElBSC2//wgj5GaSv66rA
Kj4f0gnpPRBBWkFI+KZSLHGIjEhBxnYXXufL/xw/Ui3SIZdS+YSiO6r0sBf0T6Rx
8eA1GIcgAFz1/s5X8ORS
=OCRS
-----END PGP SIGNATURE-----

--Apple-Mail=_A96589B8-D0C7-433D-9FAE-2212A365D7CF--
