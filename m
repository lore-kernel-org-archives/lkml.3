Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3AUAek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:34:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38996 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:34:39 -0500
Date: Mon, 21 Jan 2013 11:34:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Samuel <chris@csamuel.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] MODSIGN: Warn when module signature checking fails
Message-Id: <20130121113430.460efbd10537801cab90af5b@canb.auug.org.au>
In-Reply-To: <87a9s3xw9g.fsf@rustcorp.com.au>
References: <50F67D75.9080508@csamuel.org>
	<87a9s3xw9g.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_11_34_30_+1100_NQcG5s+2p=7v1epB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_11_34_30_+1100_NQcG5s+2p=7v1epB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 21 Jan 2013 10:06:11 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
>  #ifdef CONFIG_MODULE_SIG
>  	mod->sig_ok =3D info->sig_ok;
> -	if (!mod->sig_ok)
> +	if (!mod->sig_ok) {
> +		printk_once(KERN_NOTICE
> +			    "%s: module verification failed: signature and/or"
> +			    " required key missing - tainting kernel\n");

Did you forget to add "mod->name"?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_11_34_30_+1100_NQcG5s+2p=7v1epB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/I0WAAoJEECxmPOUX5FEVfYP/2Pod7zP+XE3IZ46XhOx97Dz
sbR55cvESmhtWi+pRJCjuy+ZBhOIOkAuComvTvTl4h1Sg+kBssK40HYXxseOUTi0
VRuTV4pRoUOiXwUBOjg3tCI1GnbQsiSsW9O/j5x3sizzzYKAgl4zENRvLQTmXGEh
H0xX6wjogScW/3fniCC5znPFS6UitmGcXDq4U8Gl5O3wUwvZL/3g53jY2InNyh+6
EfKNUkE4nEe8Z3uRSiOa2UFPdLuszS2uGWSXI8gncjIIPZmuQHOxlAK3Tq3m+eVy
NPXjIqCNxSybnqU/TRxYxiRqohd7Zo6umdXmBfC4ANV0r+dt/BwahxGOkN0tRysW
iXcdKBgHIWJrJSN91hYklANVKw1Nm+zFhc7QOcfbAExW7wOQ4GM4c/u0qM6f+XRp
JM5cUrOg5Frw7GViEsvhH0bq5mt6N2MbPrMASSF1Wogct/tBr3bcjr88XFqsr8dH
xQBvpgU6cOzM41xyZLUDvvmYgUycQindr7x8te9QRAqHUroP9bR2wF7bRj992TyJ
xzoa5ubBZwzim+RbFgehIRXZzr86xpQRkqSi9ep+EW0kHEpQ/U5iHk22wJoGAMtU
ACVxGqpluP3nzjSZeao7LXBuCu7iZBqMa0Bw9FckMr28ulafNca68+BN7eovVB6C
Icsc1qi5VrD9gTbiB9GK
=zRZ7
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_11_34_30_+1100_NQcG5s+2p=7v1epB--
