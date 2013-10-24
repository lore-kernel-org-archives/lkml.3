Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3JXHvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:51:04 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60306 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3JXHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:51:01 -0400
Date: Thu, 24 Oct 2013 09:50:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Usage of for_each_child_of_node()
Message-ID: <20131024075058.GD9403@ulmo.nvidia.com>
References: <5259B6F8.3070701@roeck-us.net>
 <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
 <20131023071006.GA7708@ulmo.nvidia.com>
 <20131023161644.GB20675@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <20131023161644.GB20675@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 09:16:44AM -0700, Guenter Roeck wrote:
> On Wed, Oct 23, 2013 at 09:10:07AM +0200, Thierry Reding wrote:
> > On Sat, Oct 12, 2013 at 10:15:03PM -0500, Rob Herring wrote:
> > > On Sat, Oct 12, 2013 at 3:54 PM, Guenter Roeck <linux@roeck-us.net> w=
rote:
> > > > Hi all,
> > > >
> > > > for_each_child_of_node() and similar functions increase the refcount
> > > > on each returned node and expect the caller to release the node by
> > > > calling of_node_put() when done.
> > > >
> > > > Looking through the kernel code, it appears this is hardly ever don=
e,
> > > > if at all. Some code even calls of_node_get() on returned nodes aga=
in.
> > > >
> > > > I guess this doesn't matter in cases where devicetree is a static e=
ntity.
> > > > However, this is not (or no longer) the case with devicetree overla=
ys,
> > > > or more generically in cases where devicetree nodes are added and
> > > > removed dynamically.
> > > >
> > > > Fundamental question: Would patches to fix this problem be accepted=
 upstream
> > > > ?
> > >=20
> > > Certainly.
> > >=20
> > > > Or, of course, stepping a bit back: Am I missing something essentia=
l ?
> > >=20
> > > No. I think this is frequently wrong since it typically doesn't matter
> > > for static entries as you mention.
> >=20
> > Actually, I think it actually happens to be correct most of the time.
> > The reason is that for_each_child_of_node() internally calls the
> > of_get_next_child() to iterate over all children. And that function
> > already calls of_node_put() on the "previous" node. So if all the code
> > does is to iterate over all nodes to query them, then all should be
> > fine.
> >=20
> Good, that reduces the scope of the problem significantly.
>=20
> > The only case where you actually need to drop the reference on a node is
> > if you break out of the loop (so that of_get_next_child() will not be
> > called). But that's usually the case when you need to perform some
> > operation on the node, in which case it is the right thing to hold on to
> > a reference until you're done with the node.
> >=20
> Unfortunately, there are many cases with code such as
>=20
> 	if (error)
> 		return;	/* or break; */

Well, a break isn't necessarily bad, since you could be using the node
subsequently. I imagine that depending on the exact block following the
if statement the node could also be assigned to some field within a
structure or similar, in which case this might still be valid. So it
really needs to be evaluated on a case by case basis.

If the above is actually verbatim, then yes, that's certainly an error.

> or even
> 	if (found node)
> 		return of_node_get(node);
>=20
> in the loop.

Yeah, I think all of those are probably wrong too.

Thierry

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaNFiAAoJEN0jrNd/PrOhBkMP/j6y3CVAsKmjjoN+vXzdKUSI
9wqIufhmKio6/45o9vNRoOOIHc0B1sT/V8KzlLMEKrW3qCLuaQuohE5FBVuu8u5y
VWqSrxo/EeTRNc2eL+MvA8/lkAOtzh5YgfqivWVw8xIKAuislPOD5oh66uwwa0IL
AjZCXJYhAy9BbQK/k+RabzyEQGz6pyy2da5G6cungeCQ/MJKM/q43JyBKZnZuYGy
Meydw1w+NpSG901WwBtYp+jrKCQzJtO+S6c3hLeVO2egaCXQz0hOzenAhscome3o
Uv02g0Pwpil6jWTEc3A0br88GGnTRpHwvWcLQOwJWi7Dxg1dTzFpivrC9E56ckx6
nruGE5vgYmVTNY7E5ABY3B+8SKFB6qwiV8DyefzPtF3LwB02Gj8dpfTQ7uNnwz4y
1JVUDi8Y2rVOFe3ETofF17GBkMm9LiKkzelENFk+5pnr80Tf6Nd91q99ittOCp/K
6cevzeLHdcov3d9o1wZ6CsYgwLfdwipq3gmR4nhemfY+hw/RNnOyYcQnoebJ4eiL
guhbIXI94fjzrUUBb3DVgSBgmeWQxp3F2tyvIFu7+KCUed43gd9qY+EmjJq0dl2N
7SNagqXuH4Q5SWQFpXFbDAyZYqkXFNN/2cIX5Gd+PgNwMTW1PjNyPiWZG8YOSjBn
7izD4h9CzuwMSiMtVDZf
=34Xy
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
