Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3FVKya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 06:54:30 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:56396 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3FVKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 06:54:29 -0400
Date: Sat, 22 Jun 2013 12:54:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Ben Gamari <bgamari@gmail.com>
Subject: Re: [PATCH] drm: always provide debugfs function prototypes
Message-ID: <20130622105424.GA16861@manwe>
References: <201306220038.17115.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <201306220038.17115.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 22, 2013 at 12:38:16AM +0200, Arnd Bergmann wrote:
> It is generally considered bad style to enclose function prototypes
> in header files in #ifdef. This case illustrates why that is:
> The tegra host1x driver calls into the debugfs functions if
> CONFIG_DEBUG_FS is enabled, but that code is otherwise already
> discarded by the compiler, so leaving the prototype in place
> actually makes everything work.
>=20
> drivers/gpu/host1x/drm/dc.c: In function 'tegra_dc_debugfs_init':
> drivers/gpu/host1x/drm/dc.c:1004:2: error: implicit declaration of functi=
on 'drm_debugfs_create_files' [-Werror=3Dimplicit-function-declaration]
> drivers/gpu/host1x/drm/dc.c: In function 'tegra_dc_debugfs_exit': drivers=
/gpu/host1x/drm/dc.c:1026:2: error: implicit declaration of function 'drm_d=
ebugfs_remove_files' [-Werror=3Dimplicit-function-declaration]
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ben Gamari <bgamari@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>
>=20
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 63d17ee..8bc105e 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1551,7 +1551,7 @@ extern int drm_proc_init(struct drm_minor *minor, s=
truct proc_dir_entry *root);
>  extern int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_ent=
ry *root);
> =20
>  				/* Debugfs support */
> -#if defined(CONFIG_DEBUG_FS)
> +

I don't know what good the blank line does here, but apart from that
this patch looks good to me:

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxYJgAAoJEN0jrNd/PrOhojgP/iMFxewCKkKzJ4Q5T43JZv6Q
h/6kCVdQJNB+PNE1tntThdRYgXTnJ+7cmsdf2vIy07wzxrY6QSvbsuXIx1aFJKkx
be/n1tiy6ycKPuKbqFT80tY4i3JUqzRMIl8RMVn8EJwaqkEiF3pLhxBbHnFZo1al
0CSAocJDno7Jj7M937oPttvex87GTglPYvtIMv36oJOXK+a81TBoqXo50n/lIWbs
F4bhhSle20OH2fS2RkoBslxCRHOW43Gnrrohu42nydJnVo4aRMukZgqFpH2d0kr7
0HQeTHAuYXSMHMGynRCxELjvMmQEXxRJmCQZDEWY/w/GMJ1WzinwL+hHkPPrad6F
5RIv5DXOHuL5ARShn/hqtkw9B7Q8LmbEtisI/d0D+q5UoT1Y8mNdfPN4b7QQC30L
3jQ5gve+VU4KgUEEfwAd7sq1DPtPU1oOsqswrbcO/XcrJgZTs1m3mIzyapVZH+TT
JV+iwSE9Nvzyq32KYUWd36eSw0bHgYAzLcXFlPBRBDtuEivg546fl9WPodRtWrKL
n89n+gMspW1Vg4OD0fjDGqqKVD5DEp8ku9I3l4qwsmBFafRcK/IKQcdn9m7q+Fek
PtWxC1w2LKQmHnvCrN+qZWIHmXDKkBnhgd6yHmVHCAchHyb1WEdvVMaA2VSGODoY
6DVCLyrCnkDLM/rXmW21
=1osy
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
