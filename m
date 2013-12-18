Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3LRB4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:56:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:1161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3LRB4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,504,1384329600"; 
   d="asc'?scan'208";a="426358753"
Message-ID: <1387331769.2330.12.camel@jtkirshe-mobl>
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Anjali Singhai Jain <anjali.singhai@intel.com>
Date: Tue, 17 Dec 2013 17:56:09 -0800
In-Reply-To: <20131218124657.f573d9ae178ea37fa971456d@canb.auug.org.au>
References: <20131218124657.f573d9ae178ea37fa971456d@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bpj1wp9CNtR2ivYx+FkM"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bpj1wp9CNtR2ivYx+FkM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-12-18 at 12:46 +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/intel/i40e/i40e_main.c between commit 3c325ced6aef
> ("i40e: fix null dereference") from Linus' tree and commit bc7d338fbb3f
> ("i40e: reinit flow for the main VSI") from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20

Your fix is fine, what I have in my tree is the following, so if you
want to modify your change so that the resultant code looks like this:

        struct rtnl_link_stats64 *vsi_stats =3D
i40e_get_vsi_stats_struct(vsi);
        int i;
 =20
        if (test_bit(__I40E_DOWN, &vsi->state))
               return stats;

        if (!vsi->tx_rings)
               return stats;
 =20
        rcu_read_lock();
        for (i =3D 0; i < vsi->num_queue_pairs; i++) {

--=-bpj1wp9CNtR2ivYx+FkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSsQC5AAoJEOVv75VaS+3O7lQQAJjuUL7GLZrx9wgSzEeQ17Wr
B+TvpYVDBo0M7UPBNsmh235UgRaTbs7LWUjhEsTkskwYuaVpm9bH1wqfPu8/eSvi
qSWTvduJY3l5gUdc9eCUVoUvWVrx7dDYmizriQLMUVZCFOT5c9hyAdyiDja416Xm
iCC48vQOdYuqIz4E93T7H6oIPOAqWAbggW7D100wbAo4z+G7a4181u5iOHR4wzlZ
uxbMkkifyRzDYUuJ7q1QiGeZIC8Ng+16oMNi9+5//m1jnjC1NP2Knicbci9pp3KP
j3XxI7AJRHUfe2qnj3lY600RwRl38Wi2rlvRgvwo1pzmRbKLUKupxrYz+IP33LSr
i4TnTVk6ndRyR3qcJG7zt8KPiBQjIHV9Xj2RWgpBtzv+IAU141POONcCEo17Z/sU
GcxNo5U9jBegdBvJ05/YzmX1+R2RErvvmlM3tzKUF5yKJ9XxZ6vdbAdmqZ5lYHR1
NuplLUuTaRscrNcSfy1O1xwpQC+uCtCBDs6E8obVb4eZUj9m4XspvxVokhfUVPLR
UAUZeJN8gW04x1GfBkeT0VRUNFZKAn/Mxp74beCGTe4sCAJlr83Wh87WAkEwICB1
nepxDmrgCC/mGxKX31/4xjGNf1dMViEid5padJeX4kwskcNteYSiDEJyejYPPja6
t9Z42o3+n7sdsg/Jn/Ek
=Ho12
-----END PGP SIGNATURE-----

--=-bpj1wp9CNtR2ivYx+FkM--

