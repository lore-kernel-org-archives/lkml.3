Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbbAEM6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:58:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51942 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbAEM6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:58:03 -0500
Message-ID: <54AA8A3F.8080800@ti.com>
Date: Mon, 5 Jan 2015 14:57:35 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-geode@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: geocode: remove unneeded NULL check
References: <1420008938-18423-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1420008938-18423-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="VOhWt3xoJsbr6CnsPivSglwTL2MBPXq8r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VOhWt3xoJsbr6CnsPivSglwTL2MBPXq8r
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 31/12/14 08:55, Sudip Mukherjee wrote:
> the check for info is not required as we are checking it immediately
> after gx1fb_init_fbinfo() and returnig -ENOMEM if it is NULL.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/video/fbdev/geode/gx1fb_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/geode/gx1fb_core.c b/drivers/video/fbd=
ev/geode/gx1fb_core.c
> index 2794ba1..9bee874 100644
> --- a/drivers/video/fbdev/geode/gx1fb_core.c
> +++ b/drivers/video/fbdev/geode/gx1fb_core.c
> @@ -374,10 +374,8 @@ static int gx1fb_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
>  		release_mem_region(gx1_gx_base() + 0x8300, 0x100);
>  	}
> =20
> -	if (info) {
> -		fb_dealloc_cmap(&info->cmap);
> -		framebuffer_release(info);
> -	}
> +	fb_dealloc_cmap(&info->cmap);
> +	framebuffer_release(info);
> =20
>  	return ret;
>  }
>=20

Thanks, queued for 3.20.

 Tomi



--VOhWt3xoJsbr6CnsPivSglwTL2MBPXq8r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqoo/AAoJEPo9qoy8lh71lp0P/RF9XL9XkDLO0yUeVdS3/baT
6+HUgDspBPleNF2ua1KU0EybPAX3r2Orlht3aeVm7CmmKx6FElUEN9IS7VPK7Tzm
211+PkYTCRhY1+fYcasRSduoZg2QXgiqsTQr6ZUDWZ4paNvHoQtzNTGOZXWYbXdo
+nqLoKJ94cS6wHlCF0pLbpGZy2Dc/UjcDLluLGSJdk/b7/Q/WZkitakYIo1CnkQL
6pvbt5lDucQIYMGDrmhq6U1+SdzIGGCazGblHrCleMcT9cCddYHCI8ID4S1bD4Q6
+/ewCEDYdIKw0B6ubCeNKJV/rmJmZetvc8lXyBE/wTT69oRQZhg0NX5UBS40wyA7
msKy0x4Cnc/hPsQ3W8nh5otiKEKvbD4AR2apJFE4Fchpd/vwgfJP2GjfuOabkhgZ
mV0amyNSegI8s++lyGYqn3Wlwk+D1PfXF/lUIEss5ktgrbKo9GK/WK7ea/WNZL7H
RnE1lUJpPA83c6oyLtNybXyHNGmZTdMi7y7BFZ4B3aqtVQk3frXQe5J3m0ICVtBG
eF1C/orJXsP0oX5M2V3BmjQLSOX7yEupThLEZpHY9k4u92eIi5tVxqDWUFr5AcdQ
ythYxiDelissbgBhsVxRbmfoqO0hgjRveg/RPME8mPPhQtIAHt3JIYqZJyctKbnq
/18rY1wiYkCoVA7cCqgp
=7nU4
-----END PGP SIGNATURE-----

--VOhWt3xoJsbr6CnsPivSglwTL2MBPXq8r--
