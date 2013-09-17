Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3IQP67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:58:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33927 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3IQP65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:58:57 -0400
Date: Tue, 17 Sep 2013 10:57:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 4/6] USB: gadget: s3c-hsotg: fix "protocol stall" handling
Message-ID: <20130917155754.GO15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
 <1378995532-32142-5-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="de1H0RjRxOSdb4we"
Content-Disposition: inline
In-Reply-To: <1378995532-32142-5-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--de1H0RjRxOSdb4we
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 04:18:50PM +0200, Robert Baldyga wrote:
> After normal handling of SetupDone interrupt, XferCompl interrupt occurs,=
 and
> then we enqueue new setup request. But when ep0 is stalled, there is no
> XferCompl, so we have to enqueue setup request immediately after stalling=
 ep.
> Otherwise incoming control requests won't be processed correctly.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsot=
g.c
> index dd5524c..c581cd7 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -1146,6 +1146,8 @@ static int s3c_hsotg_process_req_feature(struct s3c=
_hsotg *hsotg,
>  	return 1;
>  }
> =20
> +static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg);
> +
>  /**
>   * s3c_hsotg_process_control - process a control request
>   * @hsotg: The device state
> @@ -1245,11 +1247,12 @@ static void s3c_hsotg_process_control(struct s3c_=
hsotg *hsotg,
>  		 * don't believe we need to anything more to get the EP
>  		 * to reply with a STALL packet
>  		 */
> +
> +		 /* complete won't by called, so we enqueue setup request here */

s/by/be

--=20
balbi

--de1H0RjRxOSdb4we
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHwAAAoJEIaOsuA1yqREDiEQAITgoS0QuuRRI5f8+XHQIAoO
mmUJbUCHlvgKwfBjnhYlBD6ZGz1YLdxRQZONvH1g42lxeXE63Mb+k7ASsR2FsnD1
O400jQkku8DhJHzA12Qm2r71IxUjbz1fvKH+rI+xJbha/fSXJ9qYKwwsTq06nava
PZH4vyI0Xvjt7YJiGRuTdUBGK+Tu6AXVV+XF9gnWUOgxpm5XI4x86703E3OAgFJE
p1VLQ3/Of3oNfWCD7bTtxGfvZuJ4rw2al0lJkG0S571ELGqtpv3IW/DDYSfZJgIv
qoHQmBlSRlMYn2I0vn25ND0qTpP8T5e41GxgICThISVI47w8uewdCrrf0EWhsCNf
9Yd9WOZbTVrbw7LWakJHmFJAy5VOmm1XtC6kPVYBOUclMggOiBNpm3rhIOUVoUPc
PCwssHiU8og2cTmQBAJXnhkCV35/8pA0ESyXm+ggcpSI8iPvyh1LaInIbv5CSc+t
UnvzeJt3fOi6BdQCsYLToaD1gqYWnLO5beeJjY5KCF1IyB+XY4p0RdG8Ti6Xnvz0
kmWmfIKAaWloXeh2N+nsWX+Crzyw5anFb2Oei36CzVMKcu1UJygmneIMaUGbIVsi
3MqP/TSwmSOtGrK7Ucglf5TYmZKRISJUSVX8U3hRvWKS7P57qlsnsZiBakS6Bb/E
BECSOoolB+3uw9mARCBu
=cr6S
-----END PGP SIGNATURE-----

--de1H0RjRxOSdb4we--
