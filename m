Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaEMP3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:29:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41088 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaEMP3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:29:01 -0400
Date: Tue, 13 May 2014 10:28:29 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: [PATCH 6/8] usb: xhci: avoid warning for !PM_SLEEP
Message-ID: <20140513152829.GK1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
 <1399557141-1346645-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <1399557141-1346645-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 03:52:19PM +0200, Arnd Bergmann wrote:
> If we build a kernel with PM_SUSPEND set and no PM_SLEEP,
> we get a build warning in the xhci-plat driver about unused
> functions.
>=20
> To fix this, use "#ifdef CONFIG_PM_SLEEP", like we do in most
> other drivers nowadays.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mathias Nyman <mathias.nyman@intel.com>
> ---
>  drivers/usb/host/xhci-plat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 151901c..3473296 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -202,7 +202,7 @@ static int xhci_plat_remove(struct platform_device *d=
ev)
>  	return 0;
>  }
> =20
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP

can we just drop the ifdeferry altogether, including from SET_*_OPS
macros ? This is just ridiculous that every merge window we have tens of
patches fixing the ifdef in several drivers.

--=20
balbi

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcjodAAoJEIaOsuA1yqREdK8P/0kEvGrOvvzncs3kUdl9W3p4
RqoBcpGTiqHS5qQneB+byNVekZehYzRZyzNaZMlt57+rOnpYXLJtbRs/tJlP/J2z
JOprtQ2WxLk0Ts9AQ2hybsLqnQ/CWdIBJqKAZrHpqpDQG1bL3rjVH+qO4ZhcOOML
DiZ8lmvl4VFfYhVfHdUAo6h18tfKZXMJYWKpuYU3Fb7cVCnIn/5x01dXjYoi6JAf
aEuk5JwSfGaolS4oE/OSKSDWHrB2r/wXFKhwffsbw4BvCiCZsRNCmtocxvo1y96Q
4JZZI2Kmua5sN3h2ppJrBy2bBnyhM/mUOD0LjkMGSRQb/bm1AfGH7Ksfm9zHcbC4
jGOA2fFSAtMJOB/Bl15lLdWgk9QHP01wpH+Fk7giysK4j5Jkulkqf3+s3EeCcMWb
BUEea/l7XgPAeFM0YPJJUfamag9aNCTTuAQEPq8cJ5YJTNfc0XGTe1b5JZLQwznf
Qt1ohDy3e7pKC+ZcMOj6c79+oMLYNxdmDDLRhkr+cL1BBpWnTsPU5ZQ/SGKVeRpV
gFxzln76msNSExFJuJpm5NaWd15NF+/X5HGP6hwMWMDAd9BD/+ZMPbWdmQjJmdib
MeLsw9r9zkCoz1IJEn7tNspGMEZKdFlR83RNq9ZNQ2F6QYx0h0VQsRNKnWuC+GZi
ebj7DhXTqlBJFbw7QQFJ
=GkRr
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
