Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBGPcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:32:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:57827 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaBGPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:32:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,801,1384329600"; 
   d="asc'?scan'208";a="477662463"
Message-ID: <1391787126.5669.11.camel@intelbox>
Subject: Re: intel_sdvo_init: trying to register non-static key
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Borislav Petkov <bp@alien8.de>, Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Feb 2014 17:32:06 +0200
In-Reply-To: <20140207145149.GZ17001@phenom.ffwll.local>
References: <20140207093205.GA24395@pd.tnic> <87d2iz18vi.fsf@intel.com>
	 <1391771542.5669.6.camel@intelbox> <20140207112809.GG24395@pd.tnic>
	 <20140207145149.GZ17001@phenom.ffwll.local>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gEdIJDiLO0xpk7IGsAF+"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gEdIJDiLO0xpk7IGsAF+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-02-07 at 15:51 +0100, Daniel Vetter wrote:
> On Fri, Feb 07, 2014 at 12:28:09PM +0100, Borislav Petkov wrote:
> > On Fri, Feb 07, 2014 at 01:12:22PM +0200, Imre Deak wrote:
> > > On Fri, 2014-02-07 at 13:04 +0200, Jani Nikula wrote:
> > > > Imre, is this the same i2c_del_adapter issue you're looking at? Any
> > > > patches to try yet?
> > >=20
> > > It looks like the same issue yes. The following patch fixed it for me=
:
> > >=20
> > > http://patchwork.freedesktop.org/patch/18698/
> > >=20
> > > I'm working on an improved version of this, but the main thing - to
> > > remove the connector's sysfs entries before actually destroying the
> > > encoder and connector objects - will remain the same as in the above
> > > patch.
> >=20
> > You could shoot the final version my way so that I give it a run too.
>=20
> The final version will only change the code layout a bit, but not the
> logic. So a tested-by from you for v1 would be helpful anyway, to make
> really sure you've reported the same issue. If that's not the case then w=
e
> need to dig deeper, so better not to waste a few days waiting for v2.

I just realized it's a different issue, since it's on the init path.
Also we set the drm device as the parent for the sdvo i2c adapter as
opposed to the dp i2c adapter where it's the connector device. So the
above patch won't help in Borislav's case. I'm looking into this issue
anyway.

--Imre=20

> -Daniel


--=-gEdIJDiLO0xpk7IGsAF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJS9Px2AAoJEORIIAnNuWDFp+YH+wZ//z3cU0fiLcL80gndNjtk
plgyaYhzoQAzKvHkimfpbtsDNIifd05AMFDiNSP9oOCMyHhUltjduOYMXnrOgyG4
WYIhaeH9OeMMsw7b02n9Hbiw63T8MGYc90CYN5xejpxcciMCybzYZSoUVLBCbpuo
jagw2EMsBRfnG9zaaHJb4ne0AZxVqQ+BJB+UnccWgWJzHb+LWg6l0DNeqeoMP5W0
ALiDD931AmHB0ijMwp/i8faOjeLfWmuXqNOIZtEitdTpZj2VbprWoLwv3fcow0Cn
vol+dmwZWX6D/gqTvTKezzSL5W2tZHF8tDuZqdCn4q6dnWAas0m/6kh160KWm8Y=
=YDLZ
-----END PGP SIGNATURE-----

--=-gEdIJDiLO0xpk7IGsAF+--

