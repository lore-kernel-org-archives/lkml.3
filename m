Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbaIKQ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:57:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48230 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbaIKQ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:57:01 -0400
Date: Thu, 11 Sep 2014 11:56:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Felipe Balbi <balbi@ti.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: f_fs: replace BUG in dead-code with less serious
 WARN_ON
Message-ID: <20140911165638.GE1840@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410364225-6087-1-git-send-email-mina86@mina86.com>
 <1410364225-6087-2-git-send-email-mina86@mina86.com>
 <20140910161337.GL667@saruman.home>
 <xa1tegvi14m6.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Y7d0dPL928TPQbc"
Content-Disposition: inline
In-Reply-To: <xa1tegvi14m6.fsf@mina86.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1Y7d0dPL928TPQbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 06:52:49PM +0200, Michal Nazarewicz wrote:
> Even though the BUG() in __ffs_event_add is a dead-code, it is still
> better to warn rather then crash the system if that code ever gets
> executed.
>=20
> Reported-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/function/f_fs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> On Wed, Sep 10 2014, Felipe Balbi <balbi@ti.com> wrote:
> > WARN(1, "unknown event type %d\n", type);
> > Then you can drop pr_vdebug();
>=20
> True, but the printk call will stay in the binary whereas pr_vdebug is not

not a big deal. I'd rather get a message all the time this triggers.

> included in non-debug builds.  Furthermore, WARN() does not use pr_fmt.

not a big deal either, we will get a stack dump and can easily figure
out where that comes from.

--=20
balbi

--1Y7d0dPL928TPQbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEdRFAAoJEIaOsuA1yqRE3osP/iE18Ke6fSou3bLxw36C2wyA
YsZ68AujJftMI8JkICcaYctQOZlORQnDFqWKVnWfEhYAcwubVWjyp82wb2O47liK
7zaWhxwPkGL548up8rhlEZhm6a+5P0buDxA858ZfXsmvj4tXig9Fv3TjwxZTli+N
yPcOZYEOJbO/d2mx8833E5zfRIlO9NmQRhdnFglpFXzxCMkX4BEVyALWiyybRI7e
RII2kH4/K6e2sEhl3G8uaMBCgsfb/DwooM03dNCPviJDzrqO7ZV+lSFmBaGFK3yv
AMaq0P16CkqMjDy7mT94bvJSM9+9Z878iZRKp6BNbzcfaNyW3Y6KRZy1cxsg/rBT
h5AFqR6HKWJDeyp6CjIUVoUw5Ys6kEfL+dmEwCnhQSupkpZ5jfaj9BqbCeCFg3ap
LH/3igcpuIWSp/p0Qf1zugE48QV6CEcbiuxTOmNLwPVeHtVOmXe84BRncZgD13nB
9OMC+xPJuCbSWaBd7G11S1BZBJ7jjCK1pLTQ27eHYTGR0XTuWv8IRGPsOUcKifCB
K+f7kzWydx7qCzTwEbMZTv9o9B3WgCMk0UUwVWlci56xSKlOhJm6xHwsRaNrha8S
aASeiNx5+YnXAi2cnZ3nO8iZgBdPyLVTaN26FMAkPg5sM1KYdq6aj58CsWqhvexP
EtPNzDvfn2Zh+GT+j+z6
=uubL
-----END PGP SIGNATURE-----

--1Y7d0dPL928TPQbc--
