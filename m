Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaLJMVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:21:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37738 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaLJMVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:21:12 -0500
Date: Wed, 10 Dec 2014 13:21:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        p.zabel@pengutronix.de, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux@arm.linux.org.uk, mturquette@linaro.org, airlied@linux.ie
Subject: Re: [PATCH RFC 04/15] drm/dsi: Do not add DSI devices for the child
 nodes with input-port property
Message-ID: <20141210122105.GC23558@ulmo.nvidia.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-5-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <1418200648-32656-5-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2014 at 04:37:17PM +0800, Liu Ying wrote:
> The MIPI DSI bus driver would try to add a DSI device for a host's every
> child node which contains the reg property.  Unfortunately, the existing
> i.MX6Q/SDL MIPI DSI host device tree node's child nodes contain the reg

There aren't any existing nodes for the DSI host on i.MX. This patch
series adds support for them.

> property, but the child nodes are ports pointing to dedicated CRTCs.
> So, this patch phases out the child nodes with input-port property before
> adding DSI devices for them and updates the MIPI DSI bus OF binding
> documentation.
>=20
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
>  Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt | 4 ++++
>  drivers/gpu/drm/drm_mipi_dsi.c                              | 5 +++--
>  2 files changed, 7 insertions(+), 2 deletions(-)

Sorry, but NAK. There's no need for this special-case. I'll go into more
detail in response to patch 09/15.

Thierry

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUiDqxAAoJEN0jrNd/PrOhVKgP/juzUrsAppVY2PtOlvuMiJBm
GphVtL7zCISpwBveA6NvoY7/i+j5VgpFHcMdOr5QQEPs7+CjbaHNJMPK6wVrT9m2
QjWpwBn+K2ra0oK4Lf4lPlBMhMlt6eYMkxJ2xJoRU0SK7BozWiCKvs807yA5wBcf
qhd+hv9/R/DwK0WZwU7SpgG3B0cv1ua4zvggNA0DQ6V/p9jqQKG9RJl6Cew2mF54
/up7H0GZv15BcdG8ZezwKulOGRkcV+G1qCXj041T+6TnDUnuIvQS1wop3yZY2wvT
DLdxDMxczVjKoBivoBmHWsogrl7vftpSZy0vvjh9Nqw+eLe16X2oMC/lNh9GdikQ
zpS7lhoNBQWgXyHZrv8HbZqQlNTsVR6NZuEi4j5YlTt15DuK7/R6oOf8RKHve0jP
jc5UvygOoRkiGh07iZjVo5sAv/r680yiFLuDA4YnkNaKUeDXoWph6OBx2/5KNTCS
qiYMjNWzY6dCupID9kINctV/DtOBoQZP+Z+vFmZCRE0xPt6x/u6kmj5M0dRcK0bj
SMMHSN4GvJL4+dvp3QXR3rb4bnlRNdrQ2UX+GPA0b/X28Aol50WOLvhx0eVKJdEL
KWzidhWCR+ygs0d4NAlPRzL/y3ARggwoSGJKrLDlcJBk4Y8MAmzlOiLLwjnmeYVw
8r3MbIrxfU7STF7njSt+
=ckC4
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
