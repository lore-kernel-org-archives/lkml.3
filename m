Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3IRSlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:41:06 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36949 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3IRSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:41:03 -0400
Date: Wed, 18 Sep 2013 22:40:32 +0400
From: Andrew Savchenko <bircoph@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        suspend-devel@lists.sourceforge.net
Subject: Re: [BUG] 3.7-rc regression bisected: s2disk fails to resume image:
 Processes could not be frozen, cannot continue resuming
Message-Id: <20130918224032.84e09e0c1372dbc51c86ab1e@gmail.com>
In-Reply-To: <20130918135239.GL13318@ZenIV.linux.org.uk>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
	<20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
	<20130918135239.GL13318@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Sep_2013_22_40_32_+0400_EUO8pyOdwr8660Ag"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_22_40_32_+0400_EUO8pyOdwr8660Ag
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, 18 Sep 2013 14:52:39 +0100 Al Viro wrote:
> On Tue, Aug 27, 2013 at 07:48:43AM +0400, Andrew Savchenko wrote:
> > > Additional (but probably useless) information on this bug may be found
> > > here: https://forums.gentoo.org/viewtopic-p-7371120.html
>=20
> Something's very fishy there:
>=20
> [quote]
> Digging into suspend-utils code shows that the following ioctl fails on  =
   =20
> "/dev/snapshot":                                                         =
   =20
>                                                                          =
      =20
>                                     Code:                                =
      =20
>                           ioctl(dev, _IO(3, 1), 0);                      =
   =20
> [end quote]
>=20
> but that's _not_ anything freeze-related - that's HDIO_GETGEO, and with z=
ero
> as last argument it will fail, no matter what.  With EFAULT, if nothing
> else...
>=20
> Which ioctl() it really is?  A bit further down you write "I modified sus=
pend
> code to see errno, so freeze on /dev/snapshot fails [with EAGAIN]", so you
> have isolated the call in question.  Could you quote the actual code?

Actual code is from suspend-utils tree, swsusp.h:

static inline int freeze(int dev)
{
        return ioctl(dev, SNAPSHOT_FREEZE, 0);
}

And from suspend_ioctls.h:
#define SNAPSHOT_IOC_MAGIC      '3'
#define SNAPSHOT_FREEZE                 _IO(SNAPSHOT_IOC_MAGIC, 1)

My mistake, should be '3' instead of 3.

Best regards,
Andrew Savchenko

--Signature=_Wed__18_Sep_2013_22_40_32_+0400_EUO8pyOdwr8660Ag
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSOfO2AAoJEFZZU7lTcnVsyzMQAIzMhDwGCYPbW8lQ+GgS42pX
34YBITNd4rKvt0+YQYYqIPB5kD+WsVlgsfcEGCE7bXw3BvbdEeBJaKd1ftUr5ctY
iaRROrYIoYyqvv/ebUusrqc0E7z+R55UfYTb8qzOo9Ctnnv6RXsLlBPEv8/TZ2ZV
suM8yv9/H3gr4NDRDCIL3WbqyK1cSfNx++sPH6anf2leJH1tCFt2UKXrnv0zlcg4
vCk+4ThGqDX3KGkKF2h6ow1lABbjWrUXJ0JL76aEiUIN/I/QZsozgpL67MTXrj3r
WUc1oE0wt0B9ucg+UOAAg5uwAdeRufnUuVKP8ODPXGD3Bw0CfHhnvEiaKvVfrJNx
f02HnXWVv3rr8NKC5lTXGBaS3ss0tk0cnMZf80ZBirIUav2p9keExm4R1wzJ2xsk
kZK4cXj6bMIVS5hUQ2cKQ35WAyMdrNNxGihc1wo6mlevozh6/AIJ/9gdxSjjCXMF
gs+R9DQBGgUNL0HBCcHULHz4wBLdL1gh5pgKRgThAY4ugLqpza6lcEJfGzNi64+5
+56O6Kl6C1S1glOr8JlrXCd0J6jjs4FepUAjvHB6qUvZNzXyLwEBc0DIbJ+oXsKT
wl8aadaRZ5EYecf36xQNr71HYuPBQu8cjSTqpsdTqyTN24yYu1TSVV+G1ZsLQ+MP
EFaOdHt4eeVWoZg58Mp1
=6Kga
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_22_40_32_+0400_EUO8pyOdwr8660Ag--
