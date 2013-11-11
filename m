Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3KKGX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:23:59 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5721 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3KKGXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:23:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 10 Nov 2013 22:22:28 -0800
Date: Mon, 11 Nov 2013 07:23:39 +0100
From: Thierry Reding <treding@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: Re: [PATCH] drm/tegra: replace IS_ERR and PTR_ERR with
 PTR_ERR_OR_ZERO
Message-ID: <20131111062339.GB13878@ulmo.nvidia.com>
References: <1383724435-15380-1-git-send-email-duanj.fnst@cn.fujitsu.com>
 <527A7333.9090409@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <527A7333.9090409@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 06, 2013 at 05:49:55PM +0100, Stephen Warren wrote:
> On 11/06/2013 12:53 AM, Duan Jiong wrote:
> > This patch fixes coccinelle error regarding usage of IS_ERR and
> > PTR_ERR instead of PTR_ERR_OR_ZERO.
>=20
> > diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
>=20
> > @@ -199,10 +199,7 @@ int tegra_bo_dumb_create(struct drm_file *file, st=
ruct drm_device *drm,
> > =20
> >  	bo =3D tegra_bo_create_with_handle(file, drm, args->size, 0,
> >  					 &args->handle);
> > -	if (IS_ERR(bo))
> > -		return PTR_ERR(bo);
> > -
> > -	return 0;
> > +	return PTR_ERR_OR_ZERO(bo);
> >  }
>=20
> I suppose that's fine, although I wonder if it'll cause churn should we
> ever need to add code to the tail end of the function.

It's unlikely that we'll ever need to add to this function. But I'm not
a big fan of PTR_ERR_OR_ZERO to be honest, so I'll let this sink in for
a bit before applying.

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSgHfrAAoJEN0jrNd/PrOhMeAQALnS9eyP+UcJtjTUpY+ASuRb
tn/z5ii3p2X4H0q3/SF2xJ/DcrpbiNqgD5ARf4atIJUDpV1uXSf8YwfW2qOtteNG
OTc0TOYQse+RbYNUCVdKzQhqJuGDpk+3yuu6Z0H0WWRUDzPxhc6P2dYfkLyUCvQN
J7m7lTlpk6f78/EmDEIqgR8MhimfNcam824PzZLTIp2fFGJaKt9Ala5tzgLzzIyB
LGjXGjXbWt3TGEptmqh/lEwvPKWMbjlQLSy3R8XRcThRtOBI2rHZFHJKItGVbX+g
4cLK4cNp7evQNo11d3HXlbPch28uehi7OeL4iejlUQKtMNEtya5xHUoY8EOSw/Ke
Rx9n0gDaIF/BFyVkJ7AY8ZNej07uXwQ7zz29DZmIqVR/FK9VhiRLPC8BKe9vt0UD
aW9EmlVHKSuAIuIaAwN8w0pPC75qH+eQevNMXSdd4XmEfPfdp/rrtlrgogNnzdSB
110ulE3FUkBlIP+j/3oa+NVER8MaYjhg/+ooynFM8QdqZQANCeS8KkAqwBTznOQP
EK9zV2L9ga8vEcdzOO0se6/zXmkAli9NUsA3aJd1F/s7cA8ZA4JdwBLWvlJOlU0u
QMe6COA8w9leqBYt/U8GE513UUk6kpma4RotLd6GHQZbIkruQe9bwBwy/DUBVK3Q
8mKvDantL1Q/g+fooZL1
=sY6f
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
