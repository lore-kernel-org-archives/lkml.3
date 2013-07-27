Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3G0P6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:58:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab3G0P6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:58:36 -0400
Message-ID: <1374940708.13555.37.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 27 Jul 2013 16:58:28 +0100
In-Reply-To: <20130726204722.608161811@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204722.608161811@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6o7UiWOOR4Ub/of3wTnk"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6o7UiWOOR4Ub/of3wTnk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-07-26 at 13:46 -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Changli Gao <xiaosuo@gmail.com>
>=20
> [ Upstream commit b1a5a34bd0b8767ea689e68f8ea513e9710b671e ]
>=20
> Ver and type in pppoe_hdr should be swapped as defined by RFC2516
> section-4.
>=20
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm not so sure this is suitable for stable.  It doesn't seem to be
helpful to either userland or kernel code.

In the kernel, we were checking that ver =3D=3D 1 and type =3D=3D 1 thus th=
is
wasn't hurting us.

If userland does anything more with these fields then it's probably
already working around the swapped fields.  It can work with both old
and new headers by doing:

#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(3,11,0)
	/* use pppoe_hdr fields normally */
#else
	/* definitions were wrong before, work around it */
#endif

If this is backported to stable, there is no usable version test.
Userland will have to bypass the bitfields entirely:

	type =3D *(uint8_t *)hdr & 0xf;
	ver =3D *(uint8_t *)hdr >> 4;

Ben.

> ---
>  include/uapi/linux/if_pppox.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- a/include/uapi/linux/if_pppox.h
> +++ b/include/uapi/linux/if_pppox.h
> @@ -135,11 +135,11 @@ struct pppoe_tag {
> =20
>  struct pppoe_hdr {
>  #if defined(__LITTLE_ENDIAN_BITFIELD)
> -	__u8 ver : 4;
>  	__u8 type : 4;
> +	__u8 ver : 4;
>  #elif defined(__BIG_ENDIAN_BITFIELD)
> -	__u8 type : 4;
>  	__u8 ver : 4;
> +	__u8 type : 4;
>  #else
>  #error	"Please fix <asm/byteorder.h>"
>  #endif


--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-6o7UiWOOR4Ub/of3wTnk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfPuJee/yOyVhhEJAQrDyQ//ZYz7auRwqUNl52GPl9ToyPLyPyQStNi6
yCTgCMPQtCRaqUezm/ysjZ1LJd5lIP62UqrtJZF9+GAWiDTZX59jSuCZFn2WIakW
6cJCQZ3tvVPnxHVhQEFWBd5mlhsQPVzG8FN7cMBlADhdKC60r7nCRmPSMzp25bB+
cMtKJyRBOVaQZbruxO1ZOf69XbnYt6LZRLWaMCSsoRqStnNI133EbEvGx+j3jfES
nWpTyyn8dZ2HKNmVEoh8uS4Yj49iy1du7YZWyThj+9BwdNsFyA2B1sHkasfPN7vS
aTqBR4r+Uw7XbAGi/cVUB1r972zQvJjXlorjQ4P2IHvcO3L9p8foS92fzFNmfkqz
7rjXo4eD+lbo7zCJ7JfO+1kfHxB8t1T2lJPIew70bKkXbcbvOI/BqNe639cozTU0
baX+IhQu7fFXdkz3UC4LJ/HoZ0oiYq0X5nb9DuooIJzNxiCsmhlz/rQd1IXBtsrz
3e33ZhAPrw0YqzbqX8NMwmHwqOkjPmBwckLvG0y/4sNZ7NyoDv7ZRgnQ9qEzQr3W
fzSCvlh5vIt6bzcJppIL7PZf9NLC5qedyZi21agdd/fm6RRMGmDqRQ/TvjmWGqQo
VyaJoAUAdnzkPRWtmbrCJrfQeyZdMyRJWoPduMd3us89hKpEshwi0MrEVmhIgXN0
iWHNGo/UOWI=
=T8Tc
-----END PGP SIGNATURE-----

--=-6o7UiWOOR4Ub/of3wTnk--
