Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967593AbaFQWnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:43:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584AbaFQWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:43:39 -0400
Date: Wed, 18 Jun 2014 00:43:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 3/4] drm/tegra: Request memory bandwidth for the
 display controller
Message-ID: <20140617224334.GC25309@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-4-git-send-email-tomeu.vizoso@collabora.com>
 <539F4E53.6080205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <539F4E53.6080205@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 02:06:43PM -0600, Stephen Warren wrote:
> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> > Request it based solely on the current mode's refresh rate. More
> > accurate requirements can be requested in future patches.
>=20
> > diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
>=20
> > +	bandwidth =3D mode->clock * window.bits_per_pixel / 8;
> > +	err =3D tegra124_emc_reserve_bandwidth(TEGRA_EMC_CONSUMER_DISP1, band=
width);
>=20
> DISP1 shouldn't be hard-coded here; the code should use DISP1 or DISP2
> based on head or DC identity. We certainly have some boards capable of
> dual-head operation.

On a general note, I think perhaps a better way to represent this in an
API, and perhaps this would help with making the API more generic, too,
would be to make drivers request some sort of handle in .probe() and use
that handle subsequently when making requests. That's somewhat analogous
to the PM QoS' struct pm_qos_request.

Thierry

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToMSWAAoJEN0jrNd/PrOhfj8P/iyTsGARiA5Lne+A7aJZ5AFc
ZX4Au48rgSI6RYvVl/0k/uTHr/G/DmE9XVzn+8uZQLioNJJ/jQKjxBnYC5jW/ix5
Ntvi5tdJdNCbCSioEyP1dFJxc0jeUprQkaQB2ZN/jHiOL03PJHzFnYfOJUsp2pKg
S7C9pjuc24Xcds/NKPYFkYVdm7eitG70WZmKwTu/eD0LTWwhc19WgMfMW8qsecpr
4lEwpRXy+APalXmqQQwNwsEPDUClrk4VTq5m1nufTlqhn4GaAxiNtmP/3AH1DLME
8O2IRzDjkYBl+L+CphQvI1f+TbbDxHIkGPgeAOnsANR5lrrSNA3Id6tGMfH+BKkj
l52RjmyZCvOR2Dnab+13J7pG/qCNgHrKRBEV+Ldlsi9dido7IoSR61XEkp9HEKb4
zoVNp317JgzCFV4ivsNKi9cPKPHzU8f1aun4U0y0nxN/4X4ZpsT9/rnx8C6O2h68
3Li4RnyAXuqUfp7Chqn5C/3rIFAGy1TfW/JShV23PupLrv4bkl+21uX9b/0PyhCF
dlvZeLJLHh9gRIL1jCfDE0HC7ZQYdw3KV/XpByWKhfaicUm4EglWWYuo0lCVi/0S
fUFbCU2sEV5LKwqWjkQw8W0aaPSwhaSg9/+cSrsDlcPz489sM/KP65iPZ3J5oGRr
eTk6nZwT2q2/NUc8W91u
=vNlq
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
