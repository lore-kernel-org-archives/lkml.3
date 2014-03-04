Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaCDKoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:44:00 -0500
Received: from mout.web.de ([212.227.17.12]:49244 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbaCDKn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:43:59 -0500
Date: Tue, 4 Mar 2014 11:43:55 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Subject: Re: [PATCH] bridge: multicast: add sanity check for query source
 addresses
Message-ID: <20140304104032.GB5090@Linus-Debian>
References: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
 <20140304090614.GA3952@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tuFXEhzhBeitrIAu"
Content-Disposition: inline
In-Reply-To: <20140304090614.GA3952@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:oYxIWK62ZIXqTnW4UYz6sXcpk4ULIo+t94xEa2kIYWB7C+GTNBS
 9VGoBc4GRwwxUUSRcIN9FdBKH++jp7QRsWuVUCQe9CRteOrE7tY6cbulofA0P+YIos1yv3g
 YYcpiFE4XeC0LdCdNNLBB0Uv0AksVeEjzk4pdsGT1h4Zczghj9KEcFsdT4XgeD7rmX6g39c
 sda9aKSB4qLq7gswXf63Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tuFXEhzhBeitrIAu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 10:06:14AM +0100, Hannes Frederic Sowa wrote:
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index ef66365..fb0e36f 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -1235,6 +1235,12 @@ static int br_ip6_multicast_query(struct net_bri=
dge *br,
> >  	    (port && port->state =3D=3D BR_STATE_DISABLED))
> >  		goto out;
> > =20
> > +	/* RFC2710+RFC3810 (MLDv1+MLDv2) require link-local source addresses =
*/
> > +	if (!(ipv6_addr_type(&ip6h->saddr) & IPV6_ADDR_LINKLOCAL)) {
> > +		err =3D -EINVAL;
> > +		goto out;
> > +	}
> > +
>=20
> Shouldn't we allow empty source address, here?
>=20
> Routers are supposed to drop them but bridges care. Linux uses ::
> as source address as long as no valid LL addresses are available,
> e.g. at boot-up (RFC3810 5.2.13.).

RFC3810, 5.2.13. refers to MLD reports, not queries, so that
shouldn't be relevant, section 5.1.14 should apply. Also the
bridge code only issues queries with a valid link-local source
address (see br_ip6_multicast_alloc_query() in
net/bridge/br_multicast.c). Where does Linux use :: for queries?

Cheers, Linus

--tuFXEhzhBeitrIAu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFa5qAAoJELxyPiAAt6Uvl1oP+QGdd0aPIJICqYOB0ai007x/
12t0FZGUs/LRfRjPQA2oHuCgnuoLoWEZ06wxZhmrWnb64KgqWsuIYGLAZfOT2M3a
TRkQ9FAGZqxf0386BrnPwL3HI+tHo1QOud2vIJ5Y6Q/4RLwi7aAfkJiyhr+Yi1vs
tORPX+0p7gshIdhNvDF7FsVBN+S2Id0swM00I80KBXcB139MsdVybaWr4eEsvV3d
8K8WmCbH3aSmmmnvkVcr97RZaYtxKhQWDuLucXNmacyTg2MOGoytVK8x0dt+lKBb
C0u+pGF3W7AM16rmqY5Xfiei+IsQeG87xCo0cGFSYUorkh1SqYBvBrLXYRn2U2wT
8odhUfYpupuESUl0D+8jmZx8u8bLAnuT1xop47N43kKOgFo6PNnCy1w2lyWWultE
rh2dY7FiRWWrtug7w+PB3ohxxfcfO0w/MHyK5ebdP7vgIpG4SvgnGA2JdnBC1uiO
EfIpx1HYjqqIuc3MyqVYJOymIxQGJyKm5U4N1GePoBk9RTGGrNF0Laj+2vY11eet
kNfUs169V7m7R6z93FIjsgO+ZQGCbH/w2gHx4kHG8+uKA1mdTW6law2YIzdzpGxJ
XmG+ZPPKVdiM+NTo2PRXqmYPGb6f8b/wzg6tdqP9XPPr0O/0NLMPVDj17+cFqrOR
tXFAwfA2q7ca4atv8IvL
=wzfl
-----END PGP SIGNATURE-----

--tuFXEhzhBeitrIAu--
