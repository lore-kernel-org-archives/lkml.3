Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3KMMwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:52:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35623 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3KMMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:52:30 -0500
Date: Wed, 13 Nov 2013 06:51:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
Message-ID: <20131113125149.GB28192@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384297710-29694-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1384297710-29694-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 12, 2013 at 05:08:30PM -0600, Nishanth Menon wrote:
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap=
_device.c
> index b69dd9a..f97b34b 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -621,6 +621,7 @@ static int _od_suspend_noirq(struct device *dev)
> =20
>  	if (!ret && !pm_runtime_status_suspended(dev)) {
>  		if (pm_generic_runtime_suspend(dev) =3D=3D 0) {
> +			pm_runtime_set_suspended(dev);

don't you have to disable pm_runtime around status changes ? Or is
pm_runtime already disabled by the time we get here ?

> @@ -634,10 +635,10 @@ static int _od_resume_noirq(struct device *dev)
>  	struct platform_device *pdev =3D to_platform_device(dev);
>  	struct omap_device *od =3D to_omap_device(pdev);
> =20
> -	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> -	    !pm_runtime_status_suspended(dev)) {
> +	if (od->flags & OMAP_DEVICE_SUSPENDED) {
>  		od->flags &=3D ~OMAP_DEVICE_SUSPENDED;
>  		omap_device_enable(pdev);
> +		pm_runtime_set_active(dev);

ditto, also pm_runtime_set_active() may fail.

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSg3XlAAoJEIaOsuA1yqREueoQAKhHJoX6Oyj63VG6CmhMhjjk
C0lxpjN854wdSGmLFBcAjtP98I6j26xKe25AmWe3H4uUdpm+Sc4iV1iMsJIGNZh/
0aofkLSP56HbJYE/Et1x69Nc+R/Y/GuP9aJ83MB4sSIcf+qgtEACPZbND7c3g8z3
OOi6eBklyBmS0hMuKFd1L0BJyTizB8ickz5TM96iBDYGtUMmZvRB6GQViXsBJV6y
7CJY2iliUMO3k3DVZV2AtloFqhQ5q7GFbRGJCQV3appqdYH6yOvrtSop3VJHCgPM
UnbSDBixJDyxNhkuZTIhSzGgTeetjI0XD1njMyyXEZaZmlMiS5jR9+CVur2uTW0C
ui2M+lpS9kmKblkAmH3A/lhCYqlkOmZY2pHPdnw2wQXNvxdDQCpIeE9/CwqKF2Xe
lSg41lYWPAcFeyVyW1OPU/slIYf00vB4VZUWBQpLevY88LAPj3Ttk7041nef8Gfd
M2/Zz4vUK5VaCtuK0ddvpO1Vo+uU3IL2gIxd0yQiXNRSeiSMzvVSx6Z9He2ZbHNF
R/36O5QCRzgzhFN3yEOJjkZcQTNrCpQXuHFEZ2+ZNJfmBs6nCaujesF0K4qaMJQh
IMuOELm1idXPaRoUB/sgMBFv+pQPetMhqy/2z7WQJ61ZQuOok8RIr2n1UHcSRY+W
m32V7ACK3LmsPpcv8Us3
=XVBK
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
