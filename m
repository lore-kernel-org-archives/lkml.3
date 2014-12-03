Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaLCOti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:49:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46880 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaLCOtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:49:36 -0500
Date: Wed, 3 Dec 2014 08:49:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/5] i2c: omap: add trace
Message-ID: <20141203144934.GB16138@saruman>
Reply-To: <balbi@ti.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
 <1417617242-16869-6-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <1417617242-16869-6-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2014 at 06:34:02PM +0400, Alexander Kochetkov wrote:
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   45 +++++++++++++++++++++++++++++++++++=
+++---
>  1 file changed, 42 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 66506db..d2dfabe 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -283,6 +283,23 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_=
dev *i2c_dev, int reg)
>  				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
>  }
> =20
> +#ifdef dev_dbg
> +#undef dev_dbg
> +#endif
> +#define dev_dbg dev_info
> +
> +static inline void omap_i2c_dump_state(const char *func, int line,
> +	struct omap_i2c_dev *dev, const char *msg)
> +{
> +	dev_dbg(dev->dev, "%s: STAT=3D0x%04x; IE=3D0x%04x; CON=3D0x%04x; (%s:%d=
)\n",
> +		msg,
> +		omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG),
> +		omap_i2c_read_reg(dev, OMAP_I2C_IE_REG),
> +		omap_i2c_read_reg(dev, OMAP_I2C_CON_REG),
> +		func, line);
> +}
> +#define OMAP_I2C_DUMP_STATE(dev, msg) omap_i2c_dump_state(__func__, __LI=
NE__, (dev), (msg))

NAK, if you want to add traces, use, well, tracepoints :-) It makes no
sense to hack stuff like this.

--=20
balbi

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfyL+AAoJEIaOsuA1yqREDKoP/RA9tGIAPVcWPHlAj6dfMt/g
3yq8M6K973pshjmuTt4V7+EwvJvzdSqSJq6/j5OhVdh13TjMJzzDV7khgbu0LSqg
mBsh43anc/T2Quga0ibuMk3SzcxtZ3fn4074sBXD00E14SxrUglAqj17wL2QJb/q
vLfHUTv5MtYybwIUdG25INbWPRnXuV2a3hfWuK+Z24zrcEwtGeNNlQLymjumCBUT
S1WRX5R3JLvPnydOz2+F6yrigUUblw0Fcpdm45jfsgUN1o9TJW2UsE36tCb6Ug/v
wntZk8yP2eY8v/C73s6c+TcU0PevOgpSrffpx8EVca95QYSEm3308rgI8VHy/qQp
KCgIvF25MKpOolrqmY2E/DXGyiSy1Nn0t61WLzsgVhZCtVpH/m8L0CI6MoT7kHTg
8ODghLdaI5N1RLfJrtsL1AjV8aGrQweD3AC6NlkWKLSTIEYIHSaOS0oB1v4I2er8
ZAlHfrxD9uLn1d2B/cajDpcvdBzh7YV+SNd82mAx/vFHd/b0BidhaPjHl40T/PCq
KQaHdTNNjY5zUXoD2IAqCtSfrkstsyb2iKcsvTm76u+xqOJYyZdRMpGiEqj3zxMl
2s7JxIP2iWiwtzLK02s9Lws4XES1iy6SRsne+xVV4dwNwifdnR9KrlDDwZ4aaqDp
zqHV/RP1hRvOIguMIDZ3
=NdNE
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
