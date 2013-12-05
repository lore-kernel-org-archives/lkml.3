Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3LENIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:08:35 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53570 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3LENIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:08:34 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] fix n900 bt error handling
Date: Thu, 5 Dec 2013 14:08:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Sebastian Reichel <sre@debian.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz> <201312041732.05400@pali> <20131205115608.GA9498@amd.pavel.ucw.cz>
In-Reply-To: <20131205115608.GA9498@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3614630.XRPW3rEMlO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312051408.30330@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3614630.XRPW3rEMlO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 05 December 2013 12:56:08 Pavel Machek wrote:
> Hi!
>=20
> > I think that we can drop "new" version, because it has
> > several problems and "old" version is working. So now it
> > not make sense to use hack or develop "new" version
> > anymore.
>=20
> Ok... but this seems still needed. Please apply,
> 							Pavel
>=20
> commit 6c65774280a7095dce8b1e995d86b2e079ef5fdb
> Author: Pavel <pavel@ucw.cz>
> Date:   Thu Dec 5 12:54:31 2013 +0100
>=20
> Cleanups should be performed even if firmware load fails.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/drivers/bluetooth/hci_h4p/core.c
> b/drivers/bluetooth/hci_h4p/core.c index ead25c4..e76e889
> 100644
> --- a/drivers/bluetooth/hci_h4p/core.c
> +++ b/drivers/bluetooth/hci_h4p/core.c
> @@ -942,7 +942,7 @@ again:
>  	err =3D hci_h4p_read_fw(info, &fw_queue);
>  	if (err < 0) {
>  		dev_err(info->dev, "Cannot read firmware\n");
> -		return err;
> +		goto err_clean;
>  	}
>=20
>  	err =3D hci_h4p_send_fw(info, &fw_queue);

Done, pushed to 3.12-rc5-n900 and 3.13-rc2-n900 branches.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3614630.XRPW3rEMlO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKges4ACgkQi/DJPQPkQ1I7kgCfdFyfd/8BD9GSzuDF0Ytn9pj2
hDkAn0dDA4E/pvGZpDw7yFFXRgCJ73zi
=y4Qs
-----END PGP SIGNATURE-----

--nextPart3614630.XRPW3rEMlO--
