Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaIZG3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:29:50 -0400
Received: from ozlabs.org ([103.22.144.67]:33548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaIZG3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:29:49 -0400
Date: Fri, 26 Sep 2014 16:29:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the watchdog tree
Message-ID: <20140926162942.161863df@canb.auug.org.au>
In-Reply-To: <5424FEE0.2020806@roeck-us.net>
References: <20140926154031.4bc4dc39@canb.auug.org.au>
	<5424FEE0.2020806@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XMl8chorLXyJpCqQTPib50W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XMl8chorLXyJpCqQTPib50W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Thu, 25 Sep 2014 22:51:28 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 09/25/2014 10:40 PM, Stephen Rothwell wrote:
> > Hi Wim,
> >
> > After merging the watchdog tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >
> >
> > drivers/watchdog/meson_wdt.c: In function 'meson_wdt_probe':
> > drivers/watchdog/meson_wdt.c:178:2: error: implicit declaration of func=
tion 'register_restart_handler' [-Werror=3Dimplicit-function-declaration]
> >    err =3D register_restart_handler(&meson_wdt->restart_handler);
> >    ^
> > drivers/watchdog/meson_wdt.c: In function 'meson_wdt_remove':
> > drivers/watchdog/meson_wdt.c:193:2: error: implicit declaration of func=
tion 'unregister_restart_handler' [-Werror=3Dimplicit-function-declaration]
> >    unregister_restart_handler(&meson_wdt->restart_handler);
> >    ^
> >
> > Caused by commit 575f4153957b ("ARM: meson: add watchdog driver").
> >
> > I have reverted that commit for today.
> >
>=20
> Those functions are defined by patches which reside in Andrew's tree.
> Is that merged later ?

Yes, Andrew's tree is merged last and part of it depends on linux-next
itself ...

We really don't want these inter tree dependencies (especially with
Andrew's tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XMl8chorLXyJpCqQTPib50W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJQfbAAoJEMDTa8Ir7ZwVZlQQAINqPfxnM2puTwNaEDCmGPuc
TuJX0c2LU9QpSMOBzBlRaoJ2Oa0PE9/2cPkfjidg2Lg12UzAqgFEx5VUG0iWO/am
u4jz04ugSxeKp/uEjNwcQbVVCIdtmmykLgmeNp/kpf/D8NxxIahi2iu87rbfWZY8
4X/LZzFVbJ5FH6QJHbKy0NAl9Ee7rjK3XogEqM0n8oc2LWbt66KNYKdA0YTkB8qI
1t5t4WAIktRjDiuh0J4K1tP9uu89yHqEW1ECzdykQF4al4FU1UXqc7BwalmH1OPG
wYKtUmRMbm/yK4acJpxd+32QeLpf9Z6mirkDfoF/hCecsni1KmR+lAeB2JPGGbeW
9efrkU6O26nW/SVjXoYqp7Ug/M+nZ7BVy/NKNsbiPuGUxAbbyOHTDCdFlt/Y/nwk
fMzyx488cM2Tn0oopwNt/jEYgaJn+m0nZNfoKAvx1rx+0dJM2UMLnGl3S8L2XPHM
GEr+rIHjvcZBBK3skZGnhxVpO8zMqgR9O+yYdsidVSzuVki3yjROucClP74eOrWp
84kDxC8XJ5wCjZ+D+x2cIX4weYe9XpdSU5pbnbl9k0s0YCiXrOiaiFRh1xjDJEff
9NY36RMU5QQJt875ffS20JzFaI3EbwI49uyedtqWSEJvddr3wKQyDOioJoxzd0YK
TVAd3ZHWM+Iwhiy5Qes1
=1i4D
-----END PGP SIGNATURE-----

--Sig_/XMl8chorLXyJpCqQTPib50W--
