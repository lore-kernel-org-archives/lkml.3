Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaIJQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:13:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51563 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJQN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:13:58 -0400
Date: Wed, 10 Sep 2014 11:13:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Felipe Balbi <balbi@ti.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] usb: f_fs: replace BUG in dead-code with less
 serious WARN_ON
Message-ID: <20140910161337.GL667@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410364225-6087-1-git-send-email-mina86@mina86.com>
 <1410364225-6087-2-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8SdtHY/0P4yzaavF"
Content-Disposition: inline
In-Reply-To: <1410364225-6087-2-git-send-email-mina86@mina86.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8SdtHY/0P4yzaavF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 05:50:25PM +0200, Michal Nazarewicz wrote:
> Even though the BUG() in __ffs_event_add is a dead-code, it is still
> better to warn rather then crash the system if that code ever gets
> executed.
>=20
> Suggested-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  This has been compile tested only.
>=20
>  drivers/usb/gadget/function/f_fs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index ec50e0d..74d48b3 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -2321,7 +2321,9 @@ static void __ffs_event_add(struct ffs_data *ffs,
>  		break;
> =20
>  	default:
> -		BUG();
> +		pr_vdebug("%d: unknown event, this should not happen\n", type);
> +		WARN_ON(1);

WARN(1, "unknown event type %d\n", type);
Then you can drop pr_vdebug();

--=20
balbi

--8SdtHY/0P4yzaavF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEHixAAoJEIaOsuA1yqREBb4QAKDLC4oY9ibwEsK/3Ld1TzJY
2p0kWQGctmNXIs2AX6AfHpUH6eNwIqPd4aPH7+XJdS8E9vZzS1/ezZBo1I1cFwGs
/wrh6JXMCZbxPWFA8wFImzg68bIVseX/t4jl8bsFSMHUmawosCUtNtuH3Qh6ngoS
KuBZoGTXjyic/XdrQy40q48Vco082vuhJL3oBVGNiQWUMCe9r3oALoY3MVqkGmAI
pHAdToIMCtpbtSAuU7c+b/OTkxcKankWiH4ZQ5Tq+b2LkTEHpWVaa3w1oe0pbvLn
k0s4VLBTqm1HD+1Q+LhxbydC+TpS28wCI5cU0ne1taTlvmnQ7HaBFHxNduwJOcFr
0Debq59hJdPJMaZuplJWeYWRs5pg+B2aZlu9QTcZ4kqaa6gT870a4OlbQWWC8CeH
7SLsfpHBbSTQrx3xvS57X/MKRiqkPiRwOowfM+DxPM0CMzUIeQSr9/Hk1BCWwa6w
fbwIiRSYBeXMZziZ4cn8cWyIeSvxby6ReDOqQbrFrq9do91WVRp7Lxreziz/W0Hw
9+vDcnQsbz8rF38CG3QoY9G48ULVbugCehiuqfw8xrM5poKSYes/JQgmsL41Iv+P
B3/2a42dzL1pYvzlnASdPRQfXNsRUJ0b0ymwCClgy9J0rXz9JA2PqGo/WmCbOMyd
bk0ZRhS+1+n+c5jvN9mq
=xl/x
-----END PGP SIGNATURE-----

--8SdtHY/0P4yzaavF--
