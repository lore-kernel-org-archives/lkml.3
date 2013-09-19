Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3ISNW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:22:57 -0400
Received: from ozlabs.org ([203.10.76.45]:43908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab3ISNWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:50 -0400
Date: Thu, 19 Sep 2013 22:33:24 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jon Loeliger <jdl@jdl.com>, Olof Johansson <olof@lixom.net>,
        frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
Message-ID: <20130919123324.GE3551@voom.redhat.com>
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 02:23:56PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> node that has a reg property must include a unit address in its name
> with value matching the first entry in its reg property. Conversely, if
> a node does not have a reg property, the node name must not include a
> unit address.
>=20
> Implement a check for this. The code doesn't validate the format of the
> unit address; ePAPR implies this may vary from binding to binding, so
> I'm not sure that it's possible to validate the value itself.
>=20
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This depends on my previous patch "Ensure all tests have matching reg
> and unit address".
>=20
> Note that this patch should not yet be applied; it will cause many real-
> world *.dts files to fail to compile. Those need to be fixed first.
> However, if/when that happens, this patch may be useful.
> ---
>  checks.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/checks.c b/checks.c
> index ee96a25..c80a055 100644
> --- a/checks.c
> +++ b/checks.c
> @@ -287,9 +287,25 @@ NODE_ERROR(node_name_chars, PROPNODECHARS "@");
>  static void check_node_name_format(struct check *c, struct node *dt,
>  				   struct node *node)
>  {
> -	if (strchr(get_unitname(node), '@'))
> +	const char *unitname;
> +	struct property *prop;
> +
> +	unitname =3D get_unitname(node);
> +
> +	if (strchr(unitname, '@'))
>  		FAIL(c, "Node %s has multiple '@' characters in name",
>  		     node->fullpath);
> +
> +	prop =3D get_property(node, "reg");
> +	if (prop) {
> +		if (!unitname[0])
> +			FAIL(c, "Node %s has a reg property, but no unit name",
> +			    node->fullpath);
> +	} else {
> +		if (unitname[0])
> +			FAIL(c, "Node %s has a unit name, but no reg property",
> +			    node->fullpath);
> +	}
>  }
>  NODE_ERROR(node_name_format, NULL, &node_name_chars);

I'd prefer to see this implemented as a new check, rather than
extending node_name_format.  It will be a bit more verbose, but it
keeps the low-level syntactic check seperate from the higher-level
semantic / linting check.

It also allows it to be configured as a warning seperately from the
simpler check.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSOu8UAAoJEGw4ysog2bOStEgQAJAEGguCvUCzdoGZAyVP5fJ+
JioFSS/hTndBrExve4GnkwRsZEhJEtbMtf3dw8ij46KVtIEvlxavzqdBFQKJ0bd9
H85REGc1hUL+elM2U5NbbzolfMpl9Jw6YhP4RnXGJbTTFoi2vm396rMKJiYVOiSP
JTKMtzKAsJJA6Mjc0DsVPFaye1qSFzVkx+OJdJxo4KIGO6hM+wq9TI9bpjNG8wOc
VBaQoGr8/pYnzRF83fK9KIGFMcPpUAQKhAIps9Od6TwVJgOgfgIfAujT4c5S8BaU
VL6TMKZwpkNRw+hEwo70X3b3f36tfGiEYmEO6WnBHNdBICRtQWDkpBF5ZQVrOIcF
AdQcZXmo4il8Xh2LHFaqgKrpkcN+S7bfKARaRGKurvCrkj5h0SkHJRyeTTLgBQB0
aL1zK0OPm28xqCCJfwgEafFdwazY+dygsBWJ3475YWsK1Aw2xSsqSXBjnQiksXcN
pbDP2KKlc6mOOAwLqGg8quHie7weY1e52pO91n0BbsbZH0hCi4xcCMXGexr54Nfb
kLNaW2tWZ2IPh/rlgNuOmDWdHZEyVGEKa9Cs/gfhvg7gBLLdZ8qxi5Y+W8QWXb51
cEbvnSzVIwGWRKeLkOol0qJbaB3j8TgQiss4GCkeHa8RNja2GDoBpE5sALw+aHjH
bHK0eFlJfki2XluQ4LN0
=rXYH
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
