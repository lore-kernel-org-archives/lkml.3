Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3CHUnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:43:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3CHUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:43:09 -0500
Date: Fri, 8 Mar 2013 21:43:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
Message-ID: <20130308204301.GA30742@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com>
 <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
 <512C84E2.5090201@nvidia.com>
 <513A0ED0.4070701@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <513A0ED0.4070701@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4WB+oa062KnHgdjK33y9R3SieFc+bTlQs3oN004Hd+G
 vX+8vXHUEbnu/MdOYUcQzuN7sRfO8SHQoma0c9Abf3YCRez9hB
 H41DtARj3HiN2FCOk3Io6a30G0PVEvM9SxUqCHOl58tt9pyam/
 x3v2qEAqfXf7PfX0dyT53lht8rx3l6JRoBDDuDUSkXTy5Goo5V
 rjktvKfmd6ZsxRENq6c6gNaJehSJVssL+N7wgDh0ZPk7D9KAHi
 1o0eXvAPW0WeGh4rj8NL5VGlPD3t7NQOLSm4FnfmeaA+XeEhta
 2CWPRyecPlmnc1SzQ/eLEC/ac0rdwoxi0t/NkBQG5yLXa4cTRm
 ZokKjwcFmDxbR/c2gGemqiUElaxYh80Oyac8BDVhETx7XieNoM
 F7WmOBQf+MWX3yWfP4/JIGaAfkmysLEp4M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 08, 2013 at 06:16:16PM +0200, Terje Bergstr=C3=B6m wrote:
> On 26.02.2013 11:48, Terje Bergstr=C3=B6m wrote:
> > On 25.02.2013 17:24, Thierry Reding wrote:
[...]
> >>> +struct mem_handle;
> >>> +struct platform_device;
> >>> +
> >>> +struct host1x_job_unpin_data {
> >>> +     struct mem_handle *h;
> >>> +     struct sg_table *mem;
> >>> +};
> >>> +
> >>> +enum mem_mgr_flag {
> >>> +     mem_mgr_flag_uncacheable =3D 0,
> >>> +     mem_mgr_flag_write_combine =3D 1,
> >>> +};
> >>
> >> I'd like to see this use a more object-oriented approach and more comm=
on
> >> terminology. All of these handles are essentially buffer objects, so
> >> maybe something like host1x_bo would be a nice and short name.
>=20
> We did this a bit differently, but following pretty much the same
> principles. We have host1x_mem_handle, which contains an ops pointer.
> The handle gets encapsulated inside drm_gem_cma_object.
>=20
> _bo structs seem to usually contains a drm_gem_object, so we thought
> it's better not to reuse that term.
>=20
> Please check the code and let us know what you think. This pretty much
> follows what Lucas proposed a while ago, and keeps neatly the DRM
> specific parts inside the drm directory.

A bo is just a buffer object, so I don't see why the name shouldn't be
used. The name is in no way specific to DRM or GEM. But the point that I
was trying to make was that there is nothing to suggest that we couldn't
use drm_gem_object as the underlying scaffold to base all host1x buffer
objects on.

Furthermore I don't understand why you've chosen this approach. It is
completely different from what other drivers do and therefore makes it
more difficult to comprehend. That alone I could live with if there were
any advantages to that approach, but as far as I can tell there are
none.

Thierry

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJROk1VAAoJEN0jrNd/PrOhWPEQAIvh04xaUpjzn4lkU6OoTv99
wFp9r8LoyCb4gwKEP4O7/QzLVLFvte90rIOSJVKaxZ6Eo8qI02mJ085OjviHYiQZ
Lh8Pm860V4chC7xchiW8M9FExGx+Hn8cNtict8jKtxa0jD03kuNSwFH0pablj2e+
MY1it3rgXX60+OBP7a67VzM9bi3iuslHpUc3i1hLRnyzqct7FKeqKSVEwam1s1Ys
APZXmSrXUK5jF4vt8iuf/bniBwCjH9IiMkIaXHecV5W+8I7tkzHxQPgRZKCMV9cu
6VnFo+mHuemdqQmYC2hRTnPLZBOEN06NQc2KnPEhQ7Wcw5XpoR+bgeFVCngpshRY
xyTXmMkAeRc+n2fMLe1DSU+zqoRevKyZAjHn95Cdeu0mrxQqMdnQCMhdhcCdyKn9
fRWMK1N93j1ISed8OuKnseXw98trgDum5HbN96g37/imIBd8ZYLskBDL5P0JT8LA
I60iRilqZ3z7IIZMfJyj/wCY6Q9MbbwFGjHeRCrOVfrLRa9awD8l/N97ClNEp7tm
2Hc9XV3pyys6yp8xE3PXZYaG5ZiHgrWox4kEzNpbEHePWFAOfIMYQLPLgQ/XmfIA
emrOPXaOpiWvmnvk1F03UAsRiLUn2wgp2rUodq5xsoB9wQ+2b7qgTXQfVzcv3+NL
+v4OYZUOhs9koLAXfQdt
=yMta
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
