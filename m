Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaJAIaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:30:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32799 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbaJAIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:30:04 -0400
Date: Wed, 1 Oct 2014 10:27:05 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        lars@metafoo.de, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH 7/9] dmaengine: Move slave caps to dma_device
Message-ID: <20141001082705.GF6884@lukather>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411808085-27792-8-git-send-email-maxime.ripard@free-electrons.com>
 <20140927092846.GA5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <20140927092846.GA5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2014 at 10:28:47AM +0100, Russell King - ARM Linux wrote:
> On Sat, Sep 27, 2014 at 10:54:43AM +0200, Maxime Ripard wrote:
> > The previous code was relying on the fact that the slave_caps were to be
> > defined on a per channel basis.
> >=20
> > However, this proved to be a bit overkill, since every driver filling t=
hese so
> > far were hardcoding it, disregarding which channel was actually given.
> >=20
> > Add these capabilities to the dma_device structure, so that drivers can=
 just
> > provide them at probe time, and be done with it.
>=20
> This is also buggy for the same reason as patch 6.

Indeed

> The only way to do this is to either have a flag day, fixing all drivers
> at once (which isn't going to happen) or leave the caps code as-is, and
> provide a library function which drivers can hook into the caps callback
> which retrieves the information from dma_device.
>=20
> That way, DMA engine drivers which are using the new method can just
> install the new function, and those which haven't been updated with
> capabilities can carry on as they are, and are detectable to drivers.

Which is pretty much the current behaviour, isn't it?

> What would be acceptable is to have the DMA engine registration function
> spot the lack of DMA caps function and print a warning at boot to
> encourage people to add it.

That would be an option too.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUK7rZAAoJEBx+YmzsjxAgl9gP+wTr87Uk2OOctggPsN/7CjvS
DUpei0pOiw4v5ZwPF54viU8pq8lTrgIWupD7AVsSYHIJNcjU6CYcjuEMAnsKrPF6
78rO0F3eYqIcZbbiTRI+7QpzSji0S1q/rPsExwd7xjt6f75lkFM2CiOhZ8RblLT+
9tDbTCqE7HyrxDGl8+yjREztM4GgFVUm6h1F0Y2Rg059JXzTYB4xZyXc8dVk4dld
heAfJHmwbTZ3aXfwtbvFrELp/CLgMkl8OFa3EhVXg7yPeR9fXgDd+8x3M1C5s8ms
HA9B03RMOvO1WpkZuIAbMkfyJAQCPmhWxLGRoHp6ikxzbDVQ6+3+DF6YLfxH/VrD
oI6MbqgHpuKLrWHd/poQ+rUc0R2fJiY9i9cyncDkx1j2DYSePvnE6i9a08bkDW/J
nkDzjG+Yv+tmX0SZTeJfQ2/trGvNh5VYvMY/5hriE0wpO/T8lijMCEU3sgl5EH6f
PgYgezq+gUf0wIT7YH6eJxslHHv4AD1q9K1GmAy2HNwzMklu1ourpKPiPUbMBr9J
eFBnzX6z0DO45/eYaVaeFz+r6Bn8TvW6EIxYyQ4tRs5WWw5bBhZUyth92oGCmFdy
Yv32dr0e7fcupzy51K8vA6pCNIgyKetxfsC/oFyDNqXB7CS6J/DP/5djB5JBJHpD
4y5b2u2VNY/vltghlSQf
=3ZKi
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
